-- ==============================================================================
-- Karighar (कारीघर) — Automated Seed Data Migration Script
-- Auto-generated on: 2026-09-13T13:13:34.285Z
-- ==============================================================================

-- 1. ARTISANS REGISTRY
INSERT INTO artisans (id, aadhaar_vault_token, full_name, phone_number, state, district, cluster_name, craft_category, pm_vishwakarma_id, trust_score, is_dbt_linked)
VALUES ('art_ramdev_01', 'vault_uid_5489_8412_varanasi', 'Master Ramdev Varma', '+91-9876543210', 'Uttar Pradesh', 'Varanasi', 'Varanasi Silk Weavers Guild #04', 'Textiles & Weaves', 'PM-VISHWAKARMA-UP-VAR-9041', 842, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO artisans (id, aadhaar_vault_token, full_name, phone_number, state, district, cluster_name, craft_category, pm_vishwakarma_id, trust_score, is_dbt_linked)
VALUES ('art_lakshmi_02', 'vault_uid_6712_9821_kutch', 'Lakshmi Ben', '+91-9876543211', 'Gujarat', 'Kutch', 'Ajrakhpur Natural Dye Cooperative', 'Block Printing & Ajrakh', 'PM-VISHWAKARMA-GJ-KUT-4412', 875, TRUE)
ON CONFLICT (id) DO NOTHING;
INSERT INTO artisans (id, aadhaar_vault_token, full_name, phone_number, state, district, cluster_name, craft_category, pm_vishwakarma_id, trust_score, is_dbt_linked)
VALUES ('art_somnath_03', 'vault_uid_8941_1204_bastar', 'Somnath Baghel', '+91-9876543212', 'Chhattisgarh', 'Bastar', 'Bastar Lost-Wax Bell Metal Guild', 'Metal Crafts', 'PM-VISHWAKARMA-CG-BAS-7819', 810, TRUE)
ON CONFLICT (id) DO NOTHING;

-- 2. CRAFT PRODUCTS
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789304737228', 'art_ramdev_01', 'Tanjore 24K Gold Foil Art Frame', 'Paintings & Art', 'Tanjore Art', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 18000, 6, 48, 'd39b628f6685d282b143da5e22d2bf305493ce21a711f25c9e9a63b1f147ba33', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789303945696', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '6b339903007f4ded994502b40bc1b0e83fbe0d5ae4179c6e6d07a236939a6fa1', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789303439217', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, 'b849ec29bd54c45c2fa4f16080022bbf7dd314c71fcaf62059298eaf34a093b3', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789302100049', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '8a5e321fb650cc335c3eabbafa45eae9f5ba150bc67b147971c5895169e6bd89', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789301707142', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '4026a2e561a2a3a305c9be1e4d1c79b9568764c32351a777a8bffab57b74a16d', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789301437648', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '21aefc2a86bf3abb4226e839aed2ec046a6f109a43a343299eec8f433d146ce1', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789245213751', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '190d4edaaad10001ba3918c992750037d98942fee2fb99713ec99cd98888a100', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789244774428', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '06ed84c90ece5c21be57fe50c3690fa3ebc20b42b12989e8bd32efcaf439aeb3', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789244304768', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, 'db0967eb70cb1b67ff5fd1b215a4257e734f0e6edcfce97a4ff73091ecf67b02', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789243963407', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '48bee6d1e8f2eb718cf99d74798c8262579d1700c56d41577176d826a2efca5c', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789243327220', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '8144910a0c94b7073d598b5e617ea114947b0fa5705a114e1af3ed9985ec9a5d', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789242978556', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, 'fb4fa933c0569c8f44a4b5a234a543cf2a36a80cf3dbbc0cc83b2f68355af343', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789242409500', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '2e90a5c303d6eef20152788c9305d63f8a5f156602c80086444bcc215798a748', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789241989837', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '45d45272aee76225a0b283cdac8b01f19e8cdb27661c9a964a7ef5086b579f62', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789239619475', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '5048056de9c854541e4c81c55795b27b71fd1ed5674a17e56c43153151bed9d6', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789239561128', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '949f7710a4b1d3aee5e0890e9acc0ceba554a1b08ef37503dc7a3f1dd89db513', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789239254855', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '6f43b83e8f353484dc315dadfa656659bb7be4af85c197e0187320ffcd8686a4', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789238559232', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '8fba9f294b2161efcb2d59d7e009121c739c9a77d20f22be8eb5a5aceff17743', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789237854898', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '644818d17934d17e0bf2afed5e4afba07d45829dde1d889644cb90930be2fdb6', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789235866871', 'art_ramdev_01', 'G20 Ceremonial Varanasi Handspun Katan Saree', 'Textiles & Weaves', 'Katan Silk Handloom', '100% Mulberry silk woven on traditional pit loom with pure silver zari border.', 8500, 1, 96, '20f6c57c4a33e8281e4d76d5b3a7c1e17fbdb3381bf492f31aa5927dce7766ff', TRUE, '{"G20 Edition","GI Certified","Pure Mulberry Silk"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789235848513', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 14500, 3, 48, '134addc1915956c4c06a2d240128c5fa6229b9d5ab358494fa90fb49fddff168', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789235838654', 'art_ramdev_01', 'Tanjore 24K Gold Foil Art Frame', 'Paintings & Art', 'Tanjore Art', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 18000, 6, 48, 'a6588cbc0f4beb1be860f40a2eb663dd9dcaa2203a9bc1bc578eedd4cb3d7792', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789235806384', 'art_ramdev_01', 'Tanjore 24K Gold Foil Art Frame', 'Paintings & Art', 'Tanjore Art', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 18000, 6, 48, '0e7034f649efbadf63025fe4941fa86f67657e75ea8973eddaffa5fc7020b8e4', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789234794233', 'art_ramdev_01', 'G20 Ceremonial Varanasi Handspun Katan Saree', 'Textiles & Weaves', 'Katan Silk Handloom', '100% Mulberry silk woven on traditional pit loom with pure silver zari border.', 8500, 1, 96, 'aec35b00d12f7f4e8319e3fbc24da1d6d5bec5e635f356c77c252a7384f369d6', TRUE, '{"G20 Edition","GI Certified","Pure Mulberry Silk"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789231923241', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, '812754603735d1cef60de26d69384f6814357cfabd07c79b26894739a8bea970', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789231914751', 'art_ramdev_01', 'Tanjore 24K Gold Foil Art Frame', 'Paintings & Art', 'Tanjore Art', 'Authentic GI-certified craft created by an artisan cooperative under MoSJE.', 18000, 6, 48, 'c9272ec7b0ed39fdbc87fa9e6e2eff27d86135d1fc11b2592018b7988aac4474', TRUE, '{"GI Certified","Handmade"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789231006871', 'art_ramdev_01', 'G20 Ceremonial Varanasi Handspun Katan Saree', 'Textiles & Weaves', 'Katan Silk Handloom', '100% Mulberry silk woven on traditional pit loom with pure silver zari border.', 8500, 1, 96, '0236cf8ec26ee84fa9f84671acfe9ecec59f36cc727c3c47f87240f7046f44d8', TRUE, '{"G20 Edition","GI Certified","Pure Mulberry Silk"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789230987165', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, '8b3153e3139c7c1b8e10dd5c703b6d52c512b4c66c6be38c1027144b4807f7f1', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789230106420', 'art_ramdev_01', 'G20 Ceremonial Varanasi Handspun Katan Saree', 'Textiles & Weaves', 'Katan Silk Handloom', '100% Mulberry silk woven on traditional pit loom with pure silver zari border.', 8500, 1, 96, '234ca62efa01a96582caec04b728f0a99880c8a0a846df1deea73658123f6fed', TRUE, '{"G20 Edition","GI Certified","Pure Mulberry Silk"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789230088770', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, '12a8b067464988469a813feee181d8da5f8299f493a1e372abd5c382af1ed3c2', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789227179300', 'art_ramdev_01', 'G20 Ceremonial Varanasi Handspun Katan Saree', 'Textiles & Weaves', 'Katan Silk Handloom', '100% Mulberry silk woven on traditional pit loom with pure silver zari border.', 8500, 1, 96, 'b1a17e3034cabda8770201bc00f729f96f11a8948ed8b85a87af6bd32caf8da7', TRUE, '{"G20 Edition","GI Certified","Pure Mulberry Silk"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789227160049', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, '486d28aec094da6c0313bb3d1ee9f94398ef497ae5b66423422f13bba8ae9665', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789226887748', 'art_ramdev_01', 'G20 Ceremonial Varanasi Handspun Katan Saree', 'Textiles & Weaves', 'Katan Silk Handloom', '100% Mulberry silk woven on traditional pit loom with pure silver zari border.', 8500, 1, 96, '6259da4db33239d6708c8a839bc02a2ee3d15627b8ba93c30562eaa9eb59cf6b', TRUE, '{"G20 Edition","GI Certified","Pure Mulberry Silk"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789226261213', 'art_ramdev_01', 'G20 Ceremonial Varanasi Handspun Katan Saree', 'Textiles & Weaves', 'Katan Silk Handloom', '100% Mulberry silk woven on traditional pit loom with pure silver zari border.', 8500, 1, 96, 'db238d6ec5e2a737e82f3249ba43c87fb2d55cd8774b7f4a39d83d7788b321b0', TRUE, '{"G20 Edition","GI Certified","Pure Mulberry Silk"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789226211612', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, '11ab8ce855d1aac9489a68bd56a750f68658b54fcdbe0b0ffcf8f127bc5c31d2', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789225714298', 'art_ramdev_01', 'G20 Ceremonial Varanasi Handspun Katan Saree', 'Textiles & Weaves', 'Katan Silk Handloom', '100% Mulberry silk woven on traditional pit loom with pure silver zari border.', 8500, 1, 96, 'bcb634e1a2ab00d5826aa210555a491d66e71d2fe68572717be5b8c766b8370c', TRUE, '{"G20 Edition","GI Certified","Pure Mulberry Silk"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789225690814', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, '64fb8c4b2edb748eb8d77212e798555d467f076c0b7b07f0900af9a07e4ea0e6', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789205032658', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, '5a4c13f01d7e89827ebc29b1f78188c25b245466c4c9f118e8fcec7142cca49f', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789204648913', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, '0e973b540a6e6056a2c975c3252925b527a73417acdd72ff6cd733259a56fe2c', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789204185743', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, 'e1df4f8d2d2767634650ee295b2e9a17a0a62830118f679f11b9206790fb7ed3', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789163531883', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, 'dbee13a209f68901d829ea4712a9b497c7c1e5098e15e56ee089c0350c755d68', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789163322796', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, '6b3d7cfd3bf3771ab47d11c29a0dadd50592207afc2e755d353f438db6e3d8d0', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_1789163098498', 'art_ramdev_01', 'Kashmir Pashmina Handspun Shawl', 'Textiles & Weaves', 'Pashmina Weaving', 'Authentic handwoven craft certified by Karighar.', 14500, 3, 48, '44615f53f7e0f5fb901f88146fda71b5a78cbc670cddf5a089a275179d2b3024', TRUE, '{"Handmade","GI Certified"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_01', 'art_ramdev_01', 'Varanasi Raw Mulberry Silk Handloom Saree', 'Textiles & Weaves', 'Banarasi Handloom Brocade', 'Authentic pure mulberry silk handwoven by Master Artisan Ramdev in Varanasi. Adorned with delicate silver zari border work and Grade A+ handloom weave density.', 8499, 4, 96, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', TRUE, '{"Pure Silk","GI Certified","Handloom","Varanasi Weave","Zari Border"}', 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop&q=80')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_02', 'art_ramdev_01', 'Jaipur Blue Pottery Royal Cobalt Floral Vase', 'Ceramics & Pottery', 'Turquoise Quartz Glaze', 'Lead-free, traditional quartz glaze handcrafted using Egyptian paste technique handed down through 4 generations. Fired at 850°C in traditional wood kilns.', 2450, 12, 32, '4f53cda18c2baa0c0354bb5f9a3ecbe5ed12ab4d8e11ba873c2f11161202b945', TRUE, '{"Blue Pottery","GI Certified","Lead Free","Jaipur Craft","Ceramic Art"}', 'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=800&auto=format&fit=crop&q=80')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_03', 'art_shanti_02', 'Madhubani Tree of Life Handpainted Canvas', 'Painting & Art', 'Mithila Kachni & Bharni Style', 'Intricate folk painting made with natural vegetable dyes and bamboo nibs on handmade cotton paper depicting nature and sacred ecology.', 3800, 6, 48, 'c6b8d91f24e93051bc73595f55cf552a4ef2d99d14690890a88ff88569420556', TRUE, '{"Madhubani","Folk Art","Natural Dyes","Mithila Painting","GI Certified"}', 'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=800&auto=format&fit=crop&q=80')
ON CONFLICT (id) DO NOTHING;
INSERT INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
VALUES ('prod_04', 'art_mukesh_03', 'Chanderi Gold Zari Border Silk Tissue Dupatta', 'Textiles & Weaves', 'Chanderi Handloom Weaving', 'Featherweight sheer handloom dupatta combining pure silk and fine cotton with gold zari bootis hand-interlocked into the weft.', 4200, 8, 54, '18acfa682e85efd6eab15b5e7d4f9b8c067e49129df62c159ec3dfb6070a2408', TRUE, '{"Chanderi","Handloom","Silk Tissue","Zari Booti","GI Certified"}', 'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=800&auto=format&fit=crop&q=80')
ON CONFLICT (id) DO NOTHING;

-- 3. ORDERS & ESCROW SETTLEMENTS
INSERT INTO orders (id, product_id, buyer_name, buyer_email, amount, currency, status, escrow_status, pfms_ref, polygon_tx, shipping_address)
VALUES ('ORD-2026-8149', 'prod_01', 'Corporate Gifting Client', 'buyer@delhi.gov.in', 9500, 'INR', 'delivered', 'RELEASED_TO_ARTISAN', 'PFMS-DBT-33736985', '0xe562acb4f48f1069fd11b079d47c8c9b', 'New Delhi, India')
ON CONFLICT (id) DO NOTHING;
INSERT INTO orders (id, product_id, buyer_name, buyer_email, amount, currency, status, escrow_status, pfms_ref, polygon_tx, shipping_address)
VALUES ('ORD-2026-6221', 'prod_01', 'Corporate Gifting Client', 'buyer@delhi.gov.in', 9500, 'INR', 'delivered', 'RELEASED_TO_ARTISAN', 'PFMS-DBT-36247831', '0xb3b4643ca61c7b02dbfc958f44132933', 'New Delhi, India')
ON CONFLICT (id) DO NOTHING;
INSERT INTO orders (id, product_id, buyer_name, buyer_email, amount, currency, status, escrow_status, pfms_ref, polygon_tx, shipping_address)
VALUES ('ORD-2026-2420', 'prod_01', 'Corporate Gifting Client', 'buyer@delhi.gov.in', 9500, 'INR', 'in_loom', 'locked', 'PFMS-DBT-80085643', '0xac76f496f2a8b6dd335acaa012ef4a16', 'New Delhi, India')
ON CONFLICT (id) DO NOTHING;
INSERT INTO orders (id, product_id, buyer_name, buyer_email, amount, currency, status, escrow_status, pfms_ref, polygon_tx, shipping_address)
VALUES ('ORD-2026-3614', 'prod_01', 'Corporate Gifting Client', 'buyer@delhi.gov.in', 9500, 'INR', 'delivered', 'RELEASED_TO_ARTISAN', 'PFMS-DBT-82232148', '0xdcbf439cfe88bacad594e6b89edcf658', 'New Delhi, India')
ON CONFLICT (id) DO NOTHING;
INSERT INTO orders (id, product_id, buyer_name, buyer_email, amount, currency, status, escrow_status, pfms_ref, polygon_tx, shipping_address)
VALUES ('ORD-2026-9041', 'prod_01', 'Ananya Sharma', 'buyer@delhi.gov.in', 8500, 'INR', 'delivered', 'SETTLED_TO_BENEFICIARY', 'PFMS-DBT-19712955', '0x428831236cd0853dcf7ae3de81152e70', 'New Delhi, India')
ON CONFLICT (id) DO NOTHING;
INSERT INTO orders (id, product_id, buyer_name, buyer_email, amount, currency, status, escrow_status, pfms_ref, polygon_tx, shipping_address)
VALUES ('ORD-2026-8812', 'prod_02', 'Vikramaditya Roy', 'buyer@delhi.gov.in', 8500, 'INR', 'shipped', 'in_transit', 'PFMS-DBT-80085643', '0xac76f496f2a8b6dd335acaa012ef4a16', 'New Delhi, India')
ON CONFLICT (id) DO NOTHING;

-- 4. INSTITUTIONAL PROCUREMENT TENDERS
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789304737269', 'GEM/2026/B/269266', 'Ministry of Social Justice & Empowerment', 'MoSJE National Gifting 300 Shawls', 'Handloom Textiles', 300, 60, 2200, 660000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789303945887', 'GEM/2026/SECURE/1789303945883', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789303945846', 'GEM/2026/B/992410', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789303439399', 'GEM/2026/SECURE/1789303439399', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789303439353', 'GEM/2026/B/992410-tender_gem_1789303439353', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789302100196', 'GEM/2026/SECURE/1789302100193', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789302100161', 'GEM/2026/B/992410-tender_gem_1789302100161', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789301707341', 'GEM/2026/SECURE/1789301707343', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789301707303', 'GEM/2026/B/992410-tender_gem_1789301707303', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789301437900', 'GEM/2026/SECURE/1789301437898', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789301437859', 'GEM/2026/B/992410-tender_gem_1789301437859', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789245213878', 'GEM/2026/SECURE/1789245213876', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789245213853', 'GEM/2026/B/992410-tender_gem_1789245213853', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789244774532', 'GEM/2026/SECURE/1789244774529', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789244774508', 'GEM/2026/B/992410-tender_gem_1789244774508', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789244304874', 'GEM/2026/SECURE/1789244304871', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789244304847', 'GEM/2026/B/992410-tender_gem_1789244304847', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789243963534', 'GEM/2026/SECURE/1789243963531', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789243963506', 'GEM/2026/B/992410-tender_gem_1789243963506', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789243327356', 'GEM/2026/SECURE/1789243327352', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789243327319', 'GEM/2026/B/992410-tender_gem_1789243327319', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789242978722', 'GEM/2026/SECURE/1789242978719', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789242978687', 'GEM/2026/B/992410-tender_gem_1789242978687', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789242409639', 'GEM/2026/SECURE/1789242409643', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789242409605', 'GEM/2026/B/992410-tender_gem_1789242409605', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789241990005', 'GEM/2026/SECURE/1789241990002', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789241989969', 'GEM/2026/B/992410-tender_gem_1789241989969', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789239619560', 'GEM/2026/SECURE/1789239619556', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789239619533', 'GEM/2026/B/992410-tender_gem_1789239619533', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789239561219', 'GEM/2026/SECURE/1789239561215', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789239561191', 'GEM/2026/B/992410-tender_gem_1789239561191', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789239254964', 'GEM/2026/SECURE/1789239254962', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789239254939', 'GEM/2026/B/992410-tender_gem_1789239254939', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789238559304', 'GEM/2026/SECURE/1789238559302', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789238559276', 'GEM/2026/B/992410-tender_gem_1789238559276', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789237855009', 'GEM/2026/SECURE/1789237855003', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789237854966', 'GEM/2026/B/992410-tender_gem_1789237854966', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789235863231', 'GEM/2026/B/141928', 'Ministry of Social Justice & Empowerment', 'G20 Cultural Presentation: 500 Varanasi Katan Silk Stoles', 'Textiles & Weaves', 500, 75, 2500, 1250000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789235848664', 'GEM/2026/SECURE/1789235848661', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789235848616', 'GEM/2026/B/992410-tender_gem_1789235848616', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789235838686', 'GEM/2026/B/238320', 'Ministry of Social Justice & Empowerment', 'MoSJE National Gifting 300 Shawls', 'Handloom Textiles', 300, 60, 2200, 660000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789235806409', 'GEM/2026/B/693757', 'Ministry of Social Justice & Empowerment', 'MoSJE National Gifting 300 Shawls', 'Handloom Textiles', 300, 60, 2200, 660000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789234790582', 'GEM/2026/B/523428', 'Ministry of Social Justice & Empowerment', 'G20 Cultural Presentation: 500 Varanasi Katan Silk Stoles', 'Textiles & Weaves', 500, 75, 2500, 1250000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789231923344', 'GEM/2026/SECURE/1789231923344', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789231923315', 'GEM/2026/B/992410-tender_gem_1789231923315', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789231914779', 'GEM/2026/B/514102', 'Ministry of Social Justice & Empowerment', 'MoSJE National Gifting 300 Shawls', 'Handloom Textiles', 300, 60, 2200, 660000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789231003224', 'GEM/2026/B/656277', 'Ministry of Social Justice & Empowerment', 'G20 Cultural Presentation: 500 Varanasi Katan Silk Stoles', 'Textiles & Weaves', 500, 75, 2500, 1250000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789230987298', 'GEM/2026/SECURE/1789230987298', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789230987263', 'GEM/2026/B/992410-tender_gem_1789230987263', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789230102759', 'GEM/2026/B/544250', 'Ministry of Social Justice & Empowerment', 'G20 Cultural Presentation: 500 Varanasi Katan Silk Stoles', 'Textiles & Weaves', 500, 75, 2500, 1250000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789230088882', 'GEM/2026/SECURE/1789230088879', 'Ministry of Social Justice & Empowerment', 'Authenticated GeM Silk Shawl Procurement', 'Textiles & Weaves', 150, 0, 3000, 450000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789230088849', 'GEM/2026/B/992410-tender_gem_1789230088849', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789227175660', 'GEM/2026/B/788737', 'Ministry of Social Justice & Empowerment', 'G20 Cultural Presentation: 500 Varanasi Katan Silk Stoles', 'Textiles & Weaves', 500, 75, 2500, 1250000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789227160088', 'GEM/2026/B/992410-tender_gem_1789227160088', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789226884095', 'GEM/2026/B/923332', 'Ministry of Social Justice & Empowerment', 'G20 Cultural Presentation: 500 Varanasi Katan Silk Stoles', 'Textiles & Weaves', 500, 75, 2500, 1250000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789226257566', 'GEM/2026/B/940393', 'Ministry of Social Justice & Empowerment', 'G20 Cultural Presentation: 500 Varanasi Katan Silk Stoles', 'Textiles & Weaves', 500, 75, 2500, 1250000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789226211657', 'GEM/2026/B/992410-tender_gem_1789226211657', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789225710637', 'GEM/2026/B/701531', 'Ministry of Social Justice & Empowerment', 'G20 Cultural Presentation: 500 Varanasi Katan Silk Stoles', 'Textiles & Weaves', 500, 75, 2500, 1250000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789225690889', 'GEM/2026/B/992410-tender_gem_1789225690889', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789225596572', 'GEM/2026/B/717365', 'Ministry of Social Justice & Empowerment', 'G20 Cultural Presentation: 500 Varanasi Katan Silk Stoles', 'Textiles & Weaves', 500, 75, 2500, 1250000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789205032710', 'GEM/2026/B/992410-tender_gem_1789205032710', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_gem_1789204648990', 'GEM/2026/B/992410-tender_gem_1789204648990', 'Ministry of Social Justice & Empowerment', 'MoSJE Annual Presentation Gifts: 200 Pure Silk Dupattas', 'Textiles & Weaves', 200, 0, 2500, 500000, '2026-11-30', '5007', 'open_for_pooling', 'Official GeM procurement tender ingested into Karighar cluster network.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_taj_500', 'GEM/2026/B/636117', 'Taj Luxury Hotels Group', 'Corporate Gifting: 500 Varanasi Brocade Silk Sarees', 'Handloom Silk', 500, 500, 2500, 1250000, '2026-10-15', '5007', 'pool_completed', 'Taj Group annual VIP guest presentation souvenirs. Strict GI-certification and weaver authentication required.')
ON CONFLICT (id) DO NOTHING;
INSERT INTO tenders (id, gem_portal_reference, issuing_ministry, title, category, total_quantity, pooled_quantity, max_budget_per_unit, total_budget_value, deadline, hsn_code, status, description)
VALUES ('tender_mea_250', 'GEM/2026/B/466613', 'Ministry of External Affairs (MEA)', 'Diplomatic Gifts: 250 Mithila Heritage Paintings', 'Folk Art', 250, 175, 3200, 800000, '2026-11-01', '9701', 'open_for_pooling', 'Official state gift hampers for visiting foreign delegates. Kachni style on handmade sun-dried paper.')
ON CONFLICT (id) DO NOTHING;

-- 5. PM-VISHWAKARMA CREDIT PROFILES
INSERT INTO credit_profiles (artisan_id, credit_score, rating_tier, on_time_delivery_rate, average_weave_quality, verified_dbt_turnover, pre_approved_loan_amount, interest_rate_per_annum, tenure_months, linked_bank_account)
VALUES ('art_ramdev_01', 842, 'Tier-1 AAA (Prime Trust)', 97.8, 98.6, 182000, 100000, 5, 18, 'State Bank of India (Aadhaar DBT linked: **********8412)')
ON CONFLICT (artisan_id) DO NOTHING;

-- 6. SOVEREIGN BLOCKCHAIN LEDGER BLOCKS
INSERT INTO blockchain_blocks (block_number, block_hash, previous_block_hash, merkle_root, validator_node, transactions_count, gas_used, block_data)
VALUES (1045, '9e12b7c4a6d8f0e2b4c6a8e0d2f4b6a8c0e2d4f6a8b0c2e4d6f8a0b2c4e6f8a0', '5d2e7a1b9c3f4e8d0a6b2c4e6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d', '0xfe492a819b4c2e6d8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f', 'MoSJE Sovereign Validator Node #1 (Varanasi)', 1, 42190, '{"blockNumber":1045,"blockHash":"0x9e12b7c4a6d8f0e2b4c6a8e0d2f4b6a8c0e2d4f6a8b0c2e4d6f8a0b2c4e6f8a0","previousHash":"0x5d2e7a1b9c3f4e8d0a6b2c4e6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d","merkleRoot":"0xfe492a819b4c2e6d8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f","timestamp":"2026-09-12T09:15:00.000Z","validator":"MoSJE Sovereign Validator Node #1 (Varanasi)","gasUsed":42190,"transactions":[{"txHash":"0x9e12b7f3a8c4e0b2d6f8a0c2e4f6a8c0e2b4d6f8","type":"PFMS_PAYOUT_RELEASE","fromAddress":"0x3a4b...escrow_vault","toAddress":"0x712a...sbi_artisan_4819","amountInr":8500,"craftId":"prod_01","payloadSummary":"SBI DBT Direct Credit for Order #ORD-2026-9041 released via PFMS callback","timestamp":"2026-09-12T09:15:00.000Z","status":"Confirmed"}]}')
ON CONFLICT (block_number) DO NOTHING;
INSERT INTO blockchain_blocks (block_number, block_hash, previous_block_hash, merkle_root, validator_node, transactions_count, gas_used, block_data)
VALUES (1044, '5d2e7a1b9c3f4e8d0a6b2c4e6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d', '8f3c7b91a4e259dc3398fe0b1124ad5687cf1092e01b34a782cd3e9a4f61ab02', '0x83b2d1f46a8c0e2b4d6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d6f8a0c', 'MoSJE Sovereign Validator Node #2 (New Delhi)', 1, 65430, '{"blockNumber":1044,"blockHash":"0x5d2e7a1b9c3f4e8d0a6b2c4e6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d","previousHash":"0x8f3c7b91a4e259dc3398fe0b1124ad5687cf1092e01b34a782cd3e9a4f61ab02","merkleRoot":"0x83b2d1f46a8c0e2b4d6f8a0c2e4f6a8c0e2b4d6f8a0c2e4f6a8c0e2b4d6f8a0c","timestamp":"2026-09-12T06:30:00.000Z","validator":"MoSJE Sovereign Validator Node #2 (New Delhi)","gasUsed":65430,"transactions":[{"txHash":"0x5d2e7a0b2c4e6f8a0c2e4f6a8c0e2b4d6f8a9041","type":"SMART_ESCROW_LOCK","fromAddress":"0x8b3c...buyer_wallet","toAddress":"0x3a4b...escrow_vault","amountInr":8500,"craftId":"prod_01","payloadSummary":"Locked ₹8,500 in Polygon-compatible Escrow Smart Contract pending delivery QR verification","timestamp":"2026-09-12T06:30:00.000Z","status":"Confirmed"}]}')
ON CONFLICT (block_number) DO NOTHING;
INSERT INTO blockchain_blocks (block_number, block_hash, previous_block_hash, merkle_root, validator_node, transactions_count, gas_used, block_data)
VALUES (1043, '8f3c7b91a4e259dc3398fe0b1124ad5687cf1092e01b34a782cd3e9a4f61ab02', '4a9b2c83d5f1e6a72b0c4e8d3f1a6c5b9e0f2d4a6c8e0b2d4f6a8c0e2b4d6f8a', '0x19a4e259dc3398fe0b1124ad5687cf1092e01b34a782cd3e9a4f61ab02384a9', 'MoSJE Sovereign Validator Node #1 (Varanasi)', 1, 98210, '{"blockNumber":1043,"blockHash":"0x8f3c7b91a4e259dc3398fe0b1124ad5687cf1092e01b34a782cd3e9a4f61ab02","previousHash":"0x4a9b2c83d5f1e6a72b0c4e8d3f1a6c5b9e0f2d4a6c8e0b2d4f6a8c0e2b4d6f8a","merkleRoot":"0x19a4e259dc3398fe0b1124ad5687cf1092e01b34a782cd3e9a4f61ab02384a9","timestamp":"2026-09-11T10:00:00.000Z","validator":"MoSJE Sovereign Validator Node #1 (Varanasi)","gasUsed":98210,"transactions":[{"txHash":"0x8f3c7b91a4e259dc3398fe0b1124ad5687cf259d","type":"GI_CRAFT_MINT","fromAddress":"0x0000...mint_contract","toAddress":"0x712a...master_ramdev","amountInr":8500,"craftId":"prod_01","payloadSummary":"Minted Digital Craft Passport GI-IN-UP-2024-VARANASI-089 (Banarasi Katan Silk Handloom Saree)","timestamp":"2026-09-11T10:00:00.000Z","status":"Confirmed"}]}')
ON CONFLICT (block_number) DO NOTHING;
INSERT INTO blockchain_blocks (block_number, block_hash, previous_block_hash, merkle_root, validator_node, transactions_count, gas_used, block_data)
VALUES (1042, '4a9b2c83d5f1e6a72b0c4e8d3f1a6c5b9e0f2d4a6c8e0b2d4f6a8c0e2b4d6f8a', '0000000000000000000000000000000000000000000000000000000000000000', '0x7b1c3d5e7a9f1b3d5f7a9c1e3b5d7f9a1c3e5b7d9f1a3c5e7b9d1f3a5c7e9b1d', 'MoSJE Genesis Sovereign Authority (MeitY/NIC)', 1, 21000, '{"blockNumber":1042,"blockHash":"0x4a9b2c83d5f1e6a72b0c4e8d3f1a6c5b9e0f2d4a6c8e0b2d4f6a8c0e2b4d6f8a","previousHash":"0x0000000000000000000000000000000000000000000000000000000000000000","merkleRoot":"0x7b1c3d5e7a9f1b3d5f7a9c1e3b5d7f9a1c3e5b7d9f1a3c5e7b9d1f3a5c7e9b1d","timestamp":"2026-08-15T00:00:00.000Z","validator":"MoSJE Genesis Sovereign Authority (MeitY/NIC)","gasUsed":21000,"transactions":[{"txHash":"0x4a9b2c83d5f1e6a72b0c4e8d3f1a6c5b9e0f0000","type":"GENESIS","fromAddress":"0x0000000000000000000000000000000000000000","toAddress":"0xmosje...national_registry","amountInr":0,"craftId":"SYSTEM","payloadSummary":"MoSJE Sovereign Proof-of-Authority (PoA) Consortium Genesis Block initialized","timestamp":"2026-08-15T00:00:00.000Z","status":"Confirmed"}]}')
ON CONFLICT (block_number) DO NOTHING;
