// ==============================================================================
// Karighar (कारीघर) — Blockchain Domain Repository
// MoSJE Sovereign Subnet (Chain 13702) Block & Transaction Queries
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const { dbAdapter } = require('../database/db_adapter');

class BlockchainRepository {
  constructor() {
    this.adapter = dbAdapter;
  }

  _getBlocks() {
    const db = this.adapter.read();
    return db.blockchainBlocks || [];
  }

  getBlocks() {
    const blocks = this._getBlocks();
    return {
      network: 'MoSJE Sovereign Subnet',
      chainId: 13702,
      blockHeight: blocks[0]?.blockNumber || 1045,
      count: blocks.length,
      blocks
    };
  }

  getTransaction(hash) {
    const cleanHash = (hash || '').toLowerCase();
    const blocks = this._getBlocks();

    for (const block of blocks) {
      for (const tx of block.transactions || []) {
        if ((tx.txHash || '').toLowerCase().includes(cleanHash)) {
          return {
            blockNumber: block.blockNumber,
            validator: block.validator,
            merkleRoot: block.merkleRoot,
            transaction: tx
          };
        }
      }
    }
    return null;
  }

  count() {
    return this._getBlocks().length;
  }
}

module.exports = new BlockchainRepository();
