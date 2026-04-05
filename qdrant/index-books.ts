/**
 * Index Books — Chunks content files and upserts into Qdrant collections.
 *
 * Usage: npx tsx qdrant/index-books.ts
 *
 * Reads all .txt files from books/ directory, chunks them with overlap,
 * embeds via OpenRouter, and upserts into per-book Qdrant collections.
 */

import * as fs from 'fs';
import * as path from 'path';

// --- Configuration ---

const QDRANT_URL = process.env.QDRANT_URL ?? 'http://localhost:6333';
const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
const BOOKS_DIR = path.resolve(__dirname, '..', 'books');
const COLLECTIONS_CONFIG = path.resolve(__dirname, 'collections.json');

const CHUNK_SIZE = 500;        // tokens (approximate, using character-based splitting)
const CHUNK_OVERLAP = 50;      // tokens overlap between chunks
const CHARS_PER_TOKEN = 4;     // rough estimate for character-to-token conversion
const EMBEDDING_MODEL = 'openai/text-embedding-3-small';
const VECTOR_SIZE = 1536;

// --- Types ---

interface CollectionConfig {
  collections: Array<{
    name: string;
    bookFile: string;
    description: string;
  }>;
}

interface Chunk {
  id: string;
  text: string;
  bookName: string;
  chunkIndex: number;
  startChar: number;
  endChar: number;
}

// --- Functions ---

function loadCollections(): CollectionConfig {
  const raw = fs.readFileSync(COLLECTIONS_CONFIG, 'utf-8');
  return JSON.parse(raw) as CollectionConfig;
}

function chunkText(text: string, bookName: string): Chunk[] {
  const chunkChars = CHUNK_SIZE * CHARS_PER_TOKEN;
  const overlapChars = CHUNK_OVERLAP * CHARS_PER_TOKEN;
  const chunks: Chunk[] = [];
  let start = 0;
  let index = 0;

  while (start < text.length) {
    const end = Math.min(start + chunkChars, text.length);
    chunks.push({
      id: `${bookName}-chunk-${index}`,
      text: text.slice(start, end),
      bookName,
      chunkIndex: index,
      startChar: start,
      endChar: end,
    });
    start = end - overlapChars;
    if (start >= text.length) break;
    index++;
  }

  return chunks;
}

async function embedText(text: string): Promise<number[]> {
  if (!OPENROUTER_API_KEY) {
    throw new Error('OPENROUTER_API_KEY is required for embedding');
  }

  const response = await fetch('https://openrouter.ai/api/v1/embeddings', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${OPENROUTER_API_KEY}`,
    },
    body: JSON.stringify({
      model: EMBEDDING_MODEL,
      input: text,
    }),
  });

  if (!response.ok) {
    throw new Error(`Embedding API error: ${response.status} ${await response.text()}`);
  }

  const data = (await response.json()) as { data: Array<{ embedding: number[] }> };
  return data.data[0].embedding;
}

async function createCollection(collectionName: string): Promise<void> {
  // Delete existing collection if it exists
  await fetch(`${QDRANT_URL}/collections/${collectionName}`, { method: 'DELETE' });

  // Create new collection
  const response = await fetch(`${QDRANT_URL}/collections/${collectionName}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      vectors: {
        size: VECTOR_SIZE,
        distance: 'Cosine',
      },
    }),
  });

  if (!response.ok) {
    throw new Error(`Failed to create collection ${collectionName}: ${await response.text()}`);
  }

  console.log(`  ✓ Collection "${collectionName}" created`);
}

async function upsertChunks(collectionName: string, chunks: Chunk[]): Promise<void> {
  const batchSize = 10;

  for (let i = 0; i < chunks.length; i += batchSize) {
    const batch = chunks.slice(i, i + batchSize);
    const points = await Promise.all(
      batch.map(async (chunk, idx) => {
        const vector = await embedText(chunk.text);
        return {
          id: i + idx,
          vector,
          payload: {
            text: chunk.text,
            book: chunk.bookName,
            chunk_index: chunk.chunkIndex,
            start_char: chunk.startChar,
            end_char: chunk.endChar,
          },
        };
      })
    );

    const response = await fetch(`${QDRANT_URL}/collections/${collectionName}/points`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ points }),
    });

    if (!response.ok) {
      throw new Error(`Failed to upsert batch to ${collectionName}: ${await response.text()}`);
    }

    console.log(`  ✓ Upserted batch ${Math.floor(i / batchSize) + 1}/${Math.ceil(chunks.length / batchSize)}`);
  }
}

async function main(): Promise<void> {
  console.log('==> Starting book indexing into Qdrant...');
  console.log(`    Qdrant URL: ${QDRANT_URL}`);
  console.log(`    Books dir:  ${BOOKS_DIR}`);
  console.log('');

  const config = loadCollections();

  for (const collection of config.collections) {
    const bookPath = path.join(BOOKS_DIR, collection.bookFile);

    if (!fs.existsSync(bookPath)) {
      console.log(`  ⚠ Skipping "${collection.name}" — file not found: ${collection.bookFile}`);
      continue;
    }

    console.log(`==> Indexing: ${collection.name} (${collection.bookFile})`);

    const text = fs.readFileSync(bookPath, 'utf-8');
    const chunks = chunkText(text, collection.name);
    console.log(`    ${chunks.length} chunks generated`);

    await createCollection(collection.name);
    await upsertChunks(collection.name, chunks);

    console.log(`    ✓ "${collection.name}" indexed successfully`);
    console.log('');
  }

  console.log('==> All books indexed.');
}

main().catch((error) => {
  console.error('ERROR:', error);
  process.exit(1);
});
