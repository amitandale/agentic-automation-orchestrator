# Qdrant Book Indexing

This directory contains utilities for indexing content files into Qdrant vector collections and querying them.

## How It Works

1. `index-books.ts` reads all `.txt` files from the `books/` directory
2. Each file is split into overlapping chunks (~500 tokens with 50 token overlap)
3. Chunks are embedded via OpenRouter (using the configured embedding model)
4. Embeddings are upserted into per-book Qdrant collections
5. Collection configuration is defined in `collections.json`

## Commands

```bash
# Index all books (run once at setup, re-run if books change)
make index-books

# Test semantic search
npx tsx qdrant/query.ts "search query here"
```

## Re-Indexing

If book files are updated, re-run `make index-books`. The script will:
1. Delete existing collections
2. Recreate them with the current config
3. Re-chunk and re-embed all content

This ensures no stale data remains in the vector store.
