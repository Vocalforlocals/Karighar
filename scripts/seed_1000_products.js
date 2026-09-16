const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

const DB_PATH = path.join(__dirname, '../backend/data/database.json');
const SQLITE_PATH = path.join(__dirname, '../backend/data/karighar.sqlite');

console.log('🔄 Loading existing database...');
const db = JSON.parse(fs.readFileSync(DB_PATH, 'utf8'));

// 20 Master Artisan Profiles across 14 States
const artisans = [
  { id: 'art_ramdev_01', name: 'Master Ramdev Varma', state: 'Uttar Pradesh', cluster: 'Varanasi Silk Guild #04', coords: '25.3176° N, 82.9739° E' },
  { id: 'art_lakshmi_02', name: 'Lakshmi Ben Vankar', state: 'Gujarat', cluster: 'Ajrakhpur Dye Cooperative', coords: '23.2420° N, 69.6669° E' },
  { id: 'art_shanta_03', name: 'Shanta Devi (National Awardee)', state: 'Bihar', cluster: 'Ranti Craft Village, Madhubani', coords: '26.3548° N, 86.0717° E' },
  { id: 'art_radheshyam_04', name: 'Radheshyam Prajapati', state: 'Rajasthan', cluster: 'Kot Jewar, Jaipur', coords: '26.9124° N, 75.7873° E' },
  { id: 'art_ghulam_05', name: 'Ghulam Hassan Mir', state: 'Jammu & Kashmir', cluster: 'Zainakote Loom Cluster, Srinagar', coords: '34.0837° N, 74.7973° E' },
  { id: 'art_somappa_06', name: 'K. Somappa (Shilp Guru)', state: 'Karnataka', cluster: 'Channapatna Lacquer Guild', coords: '12.6518° N, 77.2089° E' },
  { id: 'art_manoj_07', name: 'Manoj Pandit', state: 'Bihar', cluster: 'Champanagar Tussar Cluster, Bhagalpur', coords: '25.2425° N, 86.9842° E' },
  { id: 'art_biren_08', name: 'Birendra Mahapatra', state: 'Odisha', cluster: 'Raghurajpur Heritage Crafts Village, Puri', coords: '19.8135° N, 85.8312° E' },
  { id: 'art_sukumar_09', name: 'Sukumar Baghel', state: 'Chhattisgarh', cluster: 'Kondagaon Bell Metal Cluster, Bastar', coords: '19.5982° N, 81.6688° E' },
  { id: 'art_subramanian_10', name: 'Subramanian Sthapathy', state: 'Tamil Nadu', cluster: 'Swamimalai Bronze Guild, Thanjavur', coords: '10.9572° N, 79.3274° E' },
  { id: 'art_parvati_11', name: 'Parvati Bai Maravi', state: 'Madhya Pradesh', cluster: 'Patangarh Gond Studio, Dindori', coords: '22.9514° N, 81.0827° E' },
  { id: 'art_iqbal_12', name: 'Ustad Iqbal Ahmed', state: 'Uttar Pradesh', cluster: 'Moradabad Peetal Nagari Guild', coords: '28.8386° N, 78.7733° E' },
  { id: 'art_sunita_13', name: 'Sunita Meher', state: 'Odisha', cluster: 'Bargarh Handloom Weaver Cooperative', coords: '21.3323° N, 83.6186° E' },
  { id: 'art_gurmeet_14', name: 'Gurmeet Kaur', state: 'Punjab', cluster: 'Tripuri Patiala Phulkari Society', coords: '30.3398° N, 76.3869° E' },
  { id: 'art_ananya_15', name: 'Ananya Roy', state: 'West Bengal', cluster: 'Bishnupur Baluchari Weaver Society, Bankura', coords: '23.0754° N, 87.3197° E' },
  { id: 'art_bhaskar_16', name: 'Bhaskar Chitrakar', state: 'West Bengal', cluster: 'Kalighat Patachitra Guild, Kolkata', coords: '22.5204° N, 88.3432° E' },
  { id: 'art_chotelal_17', name: 'Chotelal Kumhar', state: 'Uttar Pradesh', cluster: 'Nizamabad Black Clay Pottery SHG, Azamgarh', coords: '26.0469° N, 83.0569° E' },
  { id: 'art_devraj_18', name: 'Devraj Urs', state: 'Karnataka', cluster: 'Mandi Mohalla Inlay Works, Mysuru', coords: '12.2958° N, 76.6394° E' },
  { id: 'art_fatima_19', name: 'Fatima Zohra', state: 'Uttar Pradesh', cluster: 'Chowk Zardozi & Chikankari Guild, Lucknow', coords: '26.8693° N, 80.9125° E' },
  { id: 'art_harish_20', name: 'Harish Chandra Soni', state: 'Rajasthan', cluster: 'Johari Bazaar Meenakari Guild, Jaipur', coords: '26.9239° N, 75.8267° E' }
];

const categoryDefs = [
  {
    category: 'Textiles & Weaves',
    targetCount: 260,
    forms: [
      'Banarasi Katan Brocade', 'Kanjeevaram Mulberry Silk', 'Pashmina Cashmere Twill', 'Chanderi Zari Silk-Cotton',
      'Sambalpuri Bandha Double Ikat', 'Pochampally Ikat Handloom', 'Bhagalpuri Tussar Ghicha Weave', 'Patola Double Ikat Silk',
      'Kota Doria Fine Khat Weave', 'Patiala Phulkari Needlework', 'Lucknowi Chikankari Shadow Work', 'Ajrakh Indigo Block Print',
      'Paithani Peacock Pallu Silk', 'Maheshwari Reversible Border', 'Baluchari Narrative Figured Silk', 'Jamdani Muslin Weave',
      'Assam Muga Golden Silk', 'Kullu Geometric Woolen Weave', 'Kasavu Gold Border Cotton', 'Tangaliya Raw Wool Beaded Weave'
    ],
    items: [
      'Handwoven Heritage Saree', 'Traditional Ceremonial Dupatta', 'Pure Cashmere Stole', 'Handloom Winter Shawl',
      'Handcrafted Wall Hanging Panel', 'Unstitched Festive Kurta Set', 'Loomed Double Bedspread', 'Brocade Cushion Set (5 pcs)',
      'Running Fabric Yardage (3m)', 'Embroidered Festive Odhani', 'Artisanal Loom Muffler', 'Temple Border Dhoti & Angavastram'
    ],
    materials: [
      ['Pure Katan Silk', 'Real Zari Thread', 'Natural Indigo Dyes'],
      ['Mulberry Silk', 'Pure Gold Dipped Silver Wire'],
      ['Changthangi Cashmere Wool', 'Walnut Wood Dyes'],
      ['Raw Tussar Silk', 'Desi Cotton', 'Organic Madder Dyes'],
      ['Fine Cotton Muslin', 'Gold Lurex Weft'],
      ['Bred Wool Yarn', 'Vegetable Color Pigments']
    ],
    images: [
      'https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1609357605129-26f69add5d6e?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1607344645866-009c320c5ab8?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1594824813684-28b1db64b2ad?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?w=800&auto=format&fit=crop&q=80'
    ],
    priceRange: [1800, 36000],
    hourRange: [24, 180],
    grade: 'Grade A+ GI Handloom'
  },
  {
    category: 'Ceramics & Pottery',
    targetCount: 160,
    forms: [
      'Jaipur Blue Quartz Pottery', 'Khurja Hand-Glazed Stoneware', 'Nizamabad Silver Inlaid Black Clay',
      'Bankura Terracotta Figural Relief', 'Gorakhpur Red Clay Sculptures', 'Longpi Serpentinite Stone Pottery',
      'Molela Sacred Votive Plaque', 'Kutch Mud Mirror Lippan Pottery', 'Villianur Terracotta Urli Craft',
      'Alwar Paper-Clay Kagzi Craft'
    ],
    items: [
      'Hand-Carved Urli Floral Water Basin', 'Artisan Storage Surahi & Tumbler Set', 'Decorative Wall Relief Plaque',
      'Studio Hand-Thrown Ceramic Flower Vase', 'Chai Kulhar & Teapot Set (6 pcs)', 'Hand-Painted Ceramic Dinner Plate Set',
      'Indoor Tabletop Clay Planter', 'Traditional Ritual Diya Chandelier', 'Aromatherapy Handcrafted Clay Diffuser',
      'Earthenware Serving Casserole with Lid', 'Bonsai Glazed Shallow Pot', 'Tribal Clay Animal Statue'
    ],
    materials: [
      ['Powdered Quartz', 'Natural Glass Frit', 'Cobalt Oxide Pigment'],
      ['River Valley Alluvial Clay', 'Vegetable Smoke Wash'],
      ['Serpentine Ground Stone', 'Weathered Clay Slip'],
      ['High-Fire Stoneware Clay', 'Food-Safe Matte Glaze'],
      ['Fine Terracotta Clay', 'Natural Geru Ochre']
    ],
    images: [
      'https://images.unsplash.com/photo-1578749556568-bc2c40e68b61?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1576014131795-d4e031848465?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1592945403244-b3fbafd7f539?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1615529328331-f8917597711f?w=800&auto=format&fit=crop&q=80'
    ],
    priceRange: [550, 6800],
    hourRange: [12, 54],
    grade: 'Lead-Free Mineral Ceramic'
  },
  {
    category: 'Folk Art & Paintings',
    targetCount: 180,
    forms: [
      'Madhubani Bharni Line Art', 'Mithila Kachni Pen & Ink', 'Warli Monochromatic Tribal Art',
      'Gond Dot & Line Folklore Art', 'Odisha Palm Leaf Pattachitra Engraving', 'Tanjore 22K Gold Foil Painting',
      'Kalamkari Hand-Drawn Natural Pigment', 'Rajasthani Miniature Phad Scroll', 'Nathdwara Pichwai Temple Painting',
      'Cheriyal Narrative Canvas Scroll', 'Rogan Castor Oil Fabric Art', 'Manjusha Angika Folk Art',
      'Kalighat Watercolor Brushwork', 'Pithora Sacred Wall Art'
    ],
    items: [
      'Framed Living Room Canvas Artwork', 'Traditional Silk Hand-Painted Scroll', 'Engraved Dried Palm Leaf Folio',
      'Hand-Painted Solid Teakwood Tray', 'Ritual Heritage Wall Hanging Plaque', 'Desk Organizer with Miniature Artwork',
      'Painted Tussar Silk Hanging', 'Tribal Tree of Life Canvas', 'Temple Kamadhenu Sacred Painting',
      'Hand-Illustrated Wooden Serving Box', 'Folklore Narrative Wall Panel'
    ],
    materials: [
      ['Handmade Cotton Canvas', 'Organic Vegetable Dyes', 'Acacia Gum Binder'],
      ['Seasoned Palm Leaves', 'Lamp Black Soot Ink'],
      ['Teakwood Base', '22K Gold Leaf Foil', 'Jaipur Semi-Precious Stones'],
      ['Boiled Castor Oil Paste', 'Earth Mineral Colors'],
      ['Handmade Rice Paper', 'Natural Indigo & Henna Dyes']
    ],
    images: [
      'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1579783902614-a3fb3927b675?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1582561424760-0321d75e81fa?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1577083552431-6e5fd01aa342?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1579783928621-7a13d66a62d1?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1580136579312-94651dfd596d?w=800&auto=format&fit=crop&q=80'
    ],
    priceRange: [950, 24000],
    hourRange: [18, 96],
    grade: 'Authentic Folklore Living Heritage'
  },
  {
    category: 'Metal Crafts',
    targetCount: 150,
    forms: [
      'Bastar Dhokra Lost-Wax Casting', 'Moradabad Hand-Chiseled Brassware', 'Bidriware Zinc-Silver Damascening',
      'Swamimalai Sacred Bronze Casting', 'Aranmula Metal Alloy Mirror', 'Nachiarkoil Handcrafted Brass Lamp',
      'Kamrupi Bell Metal Beaten Ware', 'Pembarthi Sheet Metal Repoussé', 'Cuttack Tarakasi Fine Silver Filigree'
    ],
    items: [
      'Lost-Wax Bell Metal Elephant Figurine', 'Hand-Chiseled Brass Centerpiece Urli', 'Silver Inlaid Bidri Decorative Vase',
      'Cast Bronze Dancing Shiva Sculpture', 'Traditional Peacock Hanging Diya Set', 'Engraved Royal Metal Serving Platter',
      'Hand-Hammered Copper & Brass Carafe', 'Handcrafted Singing Meditation Bowl', 'Brass Tribal Musician Figurine Set (3 pcs)',
      'Ornate Brass Incense Dhoop Burner', 'Repoussé Metal Wall Crest'
    ],
    materials: [
      ['Recycled Brass Scrap', 'Beeswax Thread Matrix', 'Clay Core'],
      ['Pure Sheet Brass', 'Natural Buffing Lacquer'],
      ['Zinc-Copper Alloy', 'Fine Pure Silver Inlay Wire'],
      ['Panchaloha Sacred 5-Metal Bronze Alloy'],
      ['Hand-Hammered Kansa (Bell Metal)']
    ],
    images: [
      'https://images.unsplash.com/photo-1582738411706-bfc8e691d1c2?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1605007493699-ce65834f87f7?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1576014131795-d4e031848465?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1618220179428-22790b461013?w=800&auto=format&fit=crop&q=80'
    ],
    priceRange: [850, 19500],
    hourRange: [16, 72],
    grade: 'Lost-Wax & Chiseled Metalwork'
  },
  {
    category: 'Wood & Cane',
    targetCount: 130,
    forms: [
      'Channapatna Non-Toxic Lacquer Turned Wood', 'Saharanpur Sheesham Wood Relief Carving', 'Mysore Rosewood Tarkashi Inlay',
      'Kashmir Walnut Wood Deep Relief Carving', 'Sankheda Traditional Lacquered Teak', 'Bastar Tribal Teakwood Carvings',
      'Assam Golden Cane & Bamboo Weave', 'Tripuri Bamboo Rib Lattice Craft', 'Nirmal Lacquered Softwood Toys',
      'Kondapalli Traditional Puni Wood Figures'
    ],
    items: [
      'Hand-Carved Sheesham Jewelry Box', 'Rosewood Inlay Wall Panel of Royal Procession', 'Hand-Turned Wooden Educational Toy Stack',
      'Walnut Wood Folding Book Rest (Rehal)', 'Woven Bamboo Ambient Table Lamp', 'Hand-Carved Jali Partition Screen Panel',
      'Handcrafted Cane Picnic & Storage Hamper', 'Hand-Turned Lacquered Wooden Candle Stand', 'Tribal Hornbill Carved Wood Figurine',
      'Wooden Spice Box with Brass Latch (7 compartments)', 'Solid Teak End Table with Marquetry'
    ],
    materials: [
      ['Seasoned Sheesham Wood', 'Brass Inlay Strips', 'Beeswax Polish'],
      ['Mysore Rosewood', 'Yellow Sandalwood Splints'],
      ['Kashmir Walnut Wood', 'Natural Tung Oil'],
      ['Wrightia Tinctoria Ivory Wood', 'Non-Toxic Vegetable Lacquer'],
      ['Wild Assam Cane & River Bamboo']
    ],
    images: [
      'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1581557991964-125469da3b8a?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1544816155-12df9643f363?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1595246140625-573b715d11dc?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1538688525198-9b88f6f53126?w=800&auto=format&fit=crop&q=80'
    ],
    priceRange: [650, 16500],
    hourRange: [14, 60],
    grade: 'Seasoned Hardwood & Natural Lac'
  },
  {
    category: 'Jewelry & Stone Crafts',
    targetCount: 70,
    forms: [
      'Jaipur Kundan Meenakari Enamel', 'Cuttack Tarakasi Silver Wire Jewelry', 'Thewa 24K Gold Foil on Glass',
      'Agra Pietra Dura Marble Inlay', 'Bastar Dokra Tribal Brass Beaded Adornment', 'Jaipur Hand-Turned Lac Bangles',
      'Varanasi Gulabi Pink Enamel', 'Konark Sculptural Soapstone Carving'
    ],
    items: [
      'Choker Necklace & Jhumka Ensemble', 'Fine Silver Filigree Floral Pendant with Chain', 'Thewa Gold-on-Emerald Pendant',
      'Inlaid White Makrana Marble Keepsake Box', 'Tribal Dokra Beads Collar Statement Piece', 'Set of 4 Glass-Studded Lac Bangles',
      'Hand-Carved Soapstone Tealight Jali Lantern', 'Meenakari Peacock Brooch Pin', 'Handcrafted Silver Anklet Pair'
    ],
    materials: [
      ['925 Hallmarked Silver Wire', 'Natural Seed Pearls'],
      ['24K Pure Gold Foil', 'Fused Venetian Colored Glass'],
      ['Makrana Pure White Marble', 'Carnelian & Malachite Inlay Stones'],
      ['Forest Lac Resin', 'Polished Glass Rhinestones'],
      ['Cast Brass Beads', 'Hand-Braided Cotton Cord']
    ],
    images: [
      'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1611591475882-277adfc783d5?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1600003014755-ba31aa59c4b6?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&auto=format&fit=crop&q=80'
    ],
    priceRange: [750, 18500],
    hourRange: [10, 48],
    grade: 'GI Precision Filigree & Inlay'
  },
  {
    category: 'Leather & Fiber Crafts',
    targetCount: 50,
    forms: [
      'Kolhapuri Hand-Braided Vegetable Tanned Leather', 'Shantiniketan Batik Embossed Leather',
      'Odisha Golden Grass Eco-Weave', 'Bihar Sikki Golden Grass Craft', 'Mayurbhanj Sabai Grass Braiding',
      'Uttar Pradesh Moonj Grass Basketry'
    ],
    items: [
      'Classic Hand-Stitched Kolhapuri Leather Chappals', 'Batik Embossed Floral Leather Tote Bag',
      'Sikki Golden Grass Storage Box with Lid', 'Handcrafted Golden Grass Dining Mat Set (6 pcs)',
      'Hand-Braided Sabai Grass Floor Planter Basket', 'Moonj Fiber Eco Laundry Storage Hamper',
      'Embossed Leather Journal with Handmade Paper', 'Sisal Fiber Decorative Placemat'
    ],
    materials: [
      ['Babul Bark Tanned Buffalo Leather', 'Raw Sisal Agave Stitching Thread'],
      ['Goat Leather', 'Vegetable Batik Paste Dyes'],
      ['Wild Golden Sikki Grass', 'Munj Reed Core'],
      ['Natural Sabai Grass Braids', 'Organic Cotton Thread']
    ],
    images: [
      'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800&auto=format&fit=crop&q=80',
      'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=800&auto=format&fit=crop&q=80'
    ],
    priceRange: [450, 4200],
    hourRange: [8, 36],
    grade: 'Zero-Chemical Bio-Degradable'
  }
];

const generatedProducts = [];
let serialCounter = 1;

for (const cDef of categoryDefs) {
  for (let i = 0; i < cDef.targetCount; i++) {
    const id = `prod_gi_${String(serialCounter).padStart(4, '0')}`;
    const artisan = artisans[(serialCounter - 1) % artisans.length];
    const form = cDef.forms[i % cDef.forms.length];
    const item = cDef.items[i % cDef.items.length];
    const title = `${form} ${item}`;
    
    // Calculate deterministic tiered price
    const minP = cDef.priceRange[0];
    const maxP = cDef.priceRange[1];
    const step = (maxP - minP) / (cDef.targetCount - 1);
    const rawPrice = Math.round((minP + step * i) / 50) * 50;
    const price = Math.max(minP, Math.min(maxP, rawPrice));

    const minH = cDef.hourRange[0];
    const maxH = cDef.hourRange[1];
    const estHours = Math.round(minH + ((maxH - minH) * (i / cDef.targetCount)));

    const imagePrimary = cDef.images[i % cDef.images.length];
    const imageSecondary = cDef.images[(i + 1) % cDef.images.length];
    const materials = cDef.materials[i % cDef.materials.length];

    const stateCode = artisan.state.substring(0, 2).toUpperCase();
    const giTagNumber = `GI-IN-${stateCode}-${2010 + ((i + serialCounter) % 15)}-${String(100 + ((serialCounter * 7) % 899))}`;

    const tags = [
      'GI Certified',
      'Handmade',
      form,
      cDef.category,
      artisan.state,
      'MoSJE Verified',
      i % 2 === 0 ? 'B2C Live' : 'B2B Wholesale',
      i % 3 === 0 ? 'GeM Portal Ready' : 'Export Ready'
    ];

    const rawPayload = `${id}:${artisan.id}:${title}:${price}:${form}:${serialCounter}`;
    const sha256Hash = crypto.createHash('sha256').update(rawPayload).digest('hex');

    const desc = `Authentic ${form} handcrafted with painstaking precision by ${artisan.name} at ${artisan.cluster}. Crafted using ${materials.join(', ')}. Certified under the Ministry of Social Justice & Empowerment (MoSJE) cluster empowerment initiative.`;

    const product = {
      id,
      artisanId: artisan.id,
      artisanName: artisan.name,
      title,
      category: cDef.category,
      craftForm: form,
      description: desc,
      images: [imagePrimary, imageSecondary],
      rawImage: imagePrimary,
      price,
      estimatedHours: estHours,
      isGICertified: true,
      giTagNumber,
      clusterLocation: `${artisan.cluster}, ${artisan.state}`,
      geoCoordinates: artisan.coords,
      stockQuantity: ((serialCounter * 3) % 15) + 1,
      status: 'active',
      tags,
      materialsUsed: materials,
      aiEnhancementsApplied: ['4K Neural Studio Filter', 'Color Calibration', 'Weave Density Mapping'],
      weaveQuality: {
        grade: cDef.grade,
        epi: 100 + ((serialCounter * 3) % 40),
        ppi: 90 + ((serialCounter * 2) % 35)
      },
      sha256Hash,
      createdAt: new Date(Date.now() - ((1000 - serialCounter) * 3600000 * 4)).toISOString()
    };

    generatedProducts.push(product);
    serialCounter++;
  }
}

console.log(`✨ Generated total products: ${generatedProducts.length}`);

// Replace db.products
db.products = generatedProducts;
fs.writeFileSync(DB_PATH, JSON.stringify(db, null, 2), 'utf8');
console.log(`💾 Successfully wrote 1000 products to ${DB_PATH}`);

// Synchronize into SQLite
try {
  const { DatabaseSync } = require('node:sqlite');
  if (fs.existsSync(SQLITE_PATH)) {
    const sqliteDb = new DatabaseSync(SQLITE_PATH);
    sqliteDb.exec('DELETE FROM craft_products;');
    console.log('🧹 Cleaned existing craft_products in SQLite');

    const insertProd = sqliteDb.prepare(`
      INSERT OR REPLACE INTO craft_products (id, artisan_id, title, category, craft_form, description, price, stock_quantity, estimated_craft_hours, sha256_hash, gi_tag_certified, tags, image_url)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);

    for (const p of generatedProducts) {
      insertProd.run(
        p.id,
        p.artisanId,
        p.title,
        p.category,
        p.craftForm,
        p.description,
        Number(p.price),
        Number(p.stockQuantity),
        Number(p.estimatedHours),
        p.sha256Hash,
        p.isGICertified ? 1 : 0,
        JSON.stringify(p.tags),
        p.images[0]
      );
    }
    console.log(`💾 Successfully synchronized 1000 products into SQLite database!`);
  }
} catch (sqliteErr) {
  console.warn('⚠️ SQLite sync note:', sqliteErr.message);
}

// Category breakdown summary
const breakdown = {};
for (const p of generatedProducts) {
  breakdown[p.category] = (breakdown[p.category] || 0) + 1;
}
console.log('\n📊 Category Breakdown of 1,000 Products:');
console.table(breakdown);
