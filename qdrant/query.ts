/**
 * Query — Test semantic search against Qdrant book collections.
 *
 * Usage: npx tsx qdrant/query.ts "your search query here"
 */

const QDRANT_URL = process.env.QDRANT_URL ?? 'http://localhost:6333';
const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
const EMBEDDING_MODEL = 'openai/text-embedding-3-small';

async function embedQuery(text: string): Promise<number[]> {
  if (!OPENROUTER_API_KEY) {
    throw new Error('OPENROUTER_API_KEY is required');
  }

  const response = await fetch('https://openrouter.ai/api/v1/embeddings', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${OPENROUTER_API_KEY}`,
    },
    body: JSON.stringify({ model: EMBEDDING_MODEL, input: text }),
  });

  if (!response.ok) {
    throw new Error(`Embedding error: ${response.status}`);
  }

  const data = (await response.json()) as { data: Array<{ embedding: number[] }> };
  return data.data[0].embedding;
}

async function searchCollection(
  collectionName: string,
  vector: number[],
  limit: number = 5
): Promise<Array<{ score: number; text: string; book: string; chunkIndex: number }>> {
  const response = await fetch(`${QDRANT_URL}/collections/${collectionName}/points/search`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      vector,
      limit,
      with_payload: true,
    }),
  });

  if (!response.ok) {
    throw new Error(`Search error in ${collectionName}: ${response.status}`);
  }

  const data = (await response.json()) as {
    result: Array<{
      score: number;
      payload: { text: string; book: string; chunk_index: number };
    }>;
  };

  return data.result.map((r) => ({
    score: r.score,
    text: r.payload.text,
    book: r.payload.book,
    chunkIndex: r.payload.chunk_index,
  }));
}

async function listCollections(): Promise<string[]> {
  const response = await fetch(`${QDRANT_URL}/collections`);
  if (!response.ok) {
    throw new Error(`Failed to list collections: ${response.status}`);
  }
  const data = (await response.json()) as { result: { collections: Array<{ name: string }> } };
  return data.result.collections.map((c) => c.name);
}

async function main(): Promise<void> {
  const query = process.argv[2];
  if (!query) {
    console.error('Usage: npx tsx qdrant/query.ts "your search query"');
    process.exit(1);
  }

  console.log(`==> Searching for: "${query}"`);
  console.log('');

  const vector = await embedQuery(query);
  const collections = await listCollections();

  for (const collection of collections) {
    console.log(`--- ${collection} ---`);
    const results = await searchCollection(collection, vector, 3);

    if (results.length === 0) {
      console.log('  (no results)');
    }

    for (const result of results) {
      console.log(`  Score: ${result.score.toFixed(4)}`);
      console.log(`  Chunk: ${result.chunkIndex}`);
      console.log(`  Text:  ${result.text.substring(0, 200)}...`);
      console.log('');
    }
  }
}

main().catch((error) => {
  console.error('ERROR:', error);
  process.exit(1);
});
