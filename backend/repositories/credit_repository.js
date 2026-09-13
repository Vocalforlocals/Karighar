// ==============================================================================
// Karighar (कारीघर) — PM-Vishwakarma Credit Domain Repository
// Alternative Credit Scoring (300-900) & Subsidized Working Capital Hub
// Smart India Hackathon 2026 | MoSJE Problem Statement #26090
// ==============================================================================

const { dbAdapter } = require('../database/db_adapter');

class CreditRepository {
  constructor() {
    this.adapter = dbAdapter;
  }

  _getCreditProfiles() {
    const db = this.adapter.read();
    return db.creditProfiles || {};
  }

  _saveCreditProfiles(profiles) {
    const db = this.adapter.read();
    db.creditProfiles = profiles;
    return this.adapter.write(db);
  }

  getProfile(artisanId) {
    const profiles = this._getCreditProfiles();
    return profiles[artisanId] || {
      artisanId,
      artisanName: 'Ramdev Varma',
      creditScore: 842,
      ratingTier: 'Tier-1 AAA (Prime Trust)',
      onTimeDeliveryRate: 97.8,
      averageWeaveQuality: 98.6,
      verifiedDbtTurnover: 182000.0,
      preApprovedLoanAmount: 100000.0,
      interestRatePerAnnum: 5.0,
      tenureMonths: 18,
      linkedBankAccount: 'State Bank of India (Aadhaar DBT linked: **********8412)'
    };
  }

  disburseLoan(artisanId, requestedAmount) {
    const amount = Number(requestedAmount) || 100000.0;
    const loanRef = `PM-VISHWAKARMA-LOAN-${Math.floor(100000 + Math.random() * 900000)}`;

    const profiles = this._getCreditProfiles();
    if (!profiles[artisanId]) {
      profiles[artisanId] = this.getProfile(artisanId);
    }
    profiles[artisanId].lastDisbursedAt = new Date().toISOString();
    profiles[artisanId].activeLoanRef = loanRef;
    profiles[artisanId].currentDisbursedAmount = amount;
    this._saveCreditProfiles(profiles);

    return {
      success: true,
      loanReference: loanRef,
      amountDisbursed: amount,
      interestRate: '5.0% Subsidized (PM-Vishwakarma)',
      disbursementMode: 'Instant DBT to Aadhaar Linked Account',
      disbursedAt: new Date().toISOString()
    };
  }
}

module.exports = new CreditRepository();
