-- ==============================================================================
-- Karighar (कारीघर) — Production PostgreSQL 16 Enterprise DDL Schema
-- Ministry of Social Justice & Empowerment (MoSJE) | SIH 2026 Problem Statement #26090
-- Optimized for MeitY MeghRaj Cloud & National Informatics Centre (NIC) Hosting
-- ==============================================================================

-- Enable cryptographic and UUID extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Automatic timestamp update function
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ------------------------------------------------------------------------------
-- 1. ARTISANS REGISTRY (UIDAI Aadhaar & PM-Vishwakarma Verified)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS artisans (
    id VARCHAR(64) PRIMARY KEY,
    aadhaar_vault_token VARCHAR(128) NOT NULL UNIQUE,
    full_name VARCHAR(128) NOT NULL,
    phone_number VARCHAR(16),
    state VARCHAR(64) NOT NULL,
    district VARCHAR(64) NOT NULL,
    cluster_name VARCHAR(128) NOT NULL,
    craft_category VARCHAR(64) NOT NULL,
    pm_vishwakarma_id VARCHAR(64) UNIQUE,
    trust_score INT DEFAULT 800 CHECK (trust_score BETWEEN 300 AND 900),
    is_dbt_linked BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_artisans_craft_category ON artisans(craft_category);
CREATE INDEX IF NOT EXISTS idx_artisans_state_district ON artisans(state, district);
CREATE INDEX IF NOT EXISTS idx_artisans_trust_score ON artisans(trust_score DESC);

CREATE TRIGGER trg_artisans_updated_at
BEFORE UPDATE ON artisans
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- ------------------------------------------------------------------------------
-- 2. HANDICRAFT CATALOG & CRYPTOGRAPHIC GI PASSPORTS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS craft_products (
    id VARCHAR(64) PRIMARY KEY,
    artisan_id VARCHAR(64) REFERENCES artisans(id) ON DELETE SET NULL,
    title VARCHAR(256) NOT NULL,
    category VARCHAR(64) NOT NULL,
    craft_form VARCHAR(128) NOT NULL,
    description TEXT,
    price NUMERIC(12, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT DEFAULT 1 CHECK (stock_quantity >= 0),
    estimated_craft_hours INT DEFAULT 48,
    sha256_hash CHAR(64) NOT NULL UNIQUE,
    gi_tag_certified BOOLEAN DEFAULT TRUE,
    tags TEXT[] DEFAULT '{}',
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_products_category ON craft_products(category);
CREATE INDEX IF NOT EXISTS idx_products_price ON craft_products(price);
CREATE INDEX IF NOT EXISTS idx_products_sha256 ON craft_products(sha256_hash);
CREATE INDEX IF NOT EXISTS idx_products_tags ON craft_products USING GIN(tags);

CREATE TRIGGER trg_products_updated_at
BEFORE UPDATE ON craft_products
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- ------------------------------------------------------------------------------
-- 3. ORDERS & ESCROW SETTLEMENTS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
    id VARCHAR(64) PRIMARY KEY,
    product_id VARCHAR(64) REFERENCES craft_products(id),
    buyer_name VARCHAR(128) NOT NULL,
    buyer_email VARCHAR(128),
    amount NUMERIC(12, 2) NOT NULL,
    currency VARCHAR(8) DEFAULT 'INR',
    status VARCHAR(32) DEFAULT 'pending',
    escrow_status VARCHAR(64) DEFAULT 'HELD_IN_ESCROW',
    pfms_ref VARCHAR(64),
    polygon_tx VARCHAR(128),
    shipping_address TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_escrow_status ON orders(escrow_status);
CREATE INDEX IF NOT EXISTS idx_orders_pfms_ref ON orders(pfms_ref);

CREATE TRIGGER trg_orders_updated_at
BEFORE UPDATE ON orders
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- ------------------------------------------------------------------------------
-- 4. INSTITUTIONAL PROCUREMENT TENDERS (GeM Ingestion & Cluster Pooling)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tenders (
    id VARCHAR(64) PRIMARY KEY,
    gem_portal_reference VARCHAR(64) NOT NULL UNIQUE,
    issuing_ministry VARCHAR(128) NOT NULL,
    title VARCHAR(256) NOT NULL,
    category VARCHAR(64) NOT NULL,
    total_quantity INT NOT NULL CHECK (total_quantity > 0),
    pooled_quantity INT DEFAULT 0 CHECK (pooled_quantity >= 0),
    max_budget_per_unit NUMERIC(12, 2) NOT NULL,
    total_budget_value NUMERIC(14, 2) NOT NULL,
    deadline DATE NOT NULL,
    hsn_code VARCHAR(16) DEFAULT '5007',
    status VARCHAR(32) DEFAULT 'open_for_pooling',
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_tenders_status ON tenders(status);
CREATE INDEX IF NOT EXISTS idx_tenders_deadline ON tenders(deadline);
CREATE INDEX IF NOT EXISTS idx_tenders_gem_ref ON tenders(gem_portal_reference);

CREATE TRIGGER trg_tenders_updated_at
BEFORE UPDATE ON tenders
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

-- ------------------------------------------------------------------------------
-- 5. TENDER CLUSTER ALLOCATIONS (Loom Commitments by Artisans)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tender_commitments (
    id VARCHAR(64) PRIMARY KEY DEFAULT 'COM-' || gen_random_uuid(),
    tender_id VARCHAR(64) NOT NULL REFERENCES tenders(id) ON DELETE CASCADE,
    artisan_id VARCHAR(64) NOT NULL REFERENCES artisans(id),
    artisan_name VARCHAR(128) NOT NULL,
    cluster_name VARCHAR(128) NOT NULL,
    committed_looms INT NOT NULL CHECK (committed_looms > 0),
    committed_units INT NOT NULL CHECK (committed_units > 0),
    committed_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_commitments_tender ON tender_commitments(tender_id);
CREATE INDEX IF NOT EXISTS idx_commitments_artisan ON tender_commitments(artisan_id);

-- ------------------------------------------------------------------------------
-- 6. PM-VISHWAKARMA CREDIT PROFILES & DBT SCORE
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS credit_profiles (
    artisan_id VARCHAR(64) PRIMARY KEY REFERENCES artisans(id),
    credit_score INT NOT NULL CHECK (credit_score BETWEEN 300 AND 900),
    rating_tier VARCHAR(64) NOT NULL,
    on_time_delivery_rate NUMERIC(5, 2) DEFAULT 95.0,
    average_weave_quality NUMERIC(5, 2) DEFAULT 98.0,
    verified_dbt_turnover NUMERIC(14, 2) DEFAULT 0.0,
    pre_approved_loan_amount NUMERIC(12, 2) DEFAULT 100000.0,
    interest_rate_per_annum NUMERIC(4, 2) DEFAULT 5.0,
    tenure_months INT DEFAULT 18,
    linked_bank_account VARCHAR(128),
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------------
-- 7. SOVEREIGN BLOCKCHAIN LEDGER BLOCKS (MoSJE Subnet Chain 13702)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS blockchain_blocks (
    block_number BIGINT PRIMARY KEY,
    block_hash CHAR(64) NOT NULL UNIQUE,
    previous_block_hash CHAR(64) NOT NULL,
    merkle_root CHAR(66) NOT NULL,
    validator_node VARCHAR(128) NOT NULL,
    transactions_count INT DEFAULT 0,
    gas_used BIGINT DEFAULT 0,
    block_data JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_blockchain_blocks_hash ON blockchain_blocks(block_hash);

-- ------------------------------------------------------------------------------
-- 8. CERT-IN COMPLIANT AUDIT TRAIL (Cryptographically Hash-Chained)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS cert_in_audit_events (
    id VARCHAR(64) PRIMARY KEY,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(64) NOT NULL,
    actor VARCHAR(128) NOT NULL,
    role VARCHAR(32) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    status VARCHAR(32) NOT NULL,
    details JSONB DEFAULT '{}',
    previous_hash CHAR(64) NOT NULL,
    integrity_hash CHAR(64) NOT NULL UNIQUE
);

CREATE INDEX IF NOT EXISTS idx_audit_timestamp ON cert_in_audit_events(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_audit_action ON cert_in_audit_events(action);
CREATE INDEX IF NOT EXISTS idx_audit_actor ON cert_in_audit_events(actor);
CREATE INDEX IF NOT EXISTS idx_audit_status ON cert_in_audit_events(status);
