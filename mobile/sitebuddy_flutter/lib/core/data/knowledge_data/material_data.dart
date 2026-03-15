import 'package:site_buddy/shared/domain/models/knowledge_topic.dart';

final Map<String, KnowledgeTopic> materialKnowledge = {
  'concrete': const KnowledgeTopic(
    id: 'concrete',
    title: 'Concrete',
    definition:
        'An artificial rock composite composed of aggregate, cement, and water that cures via chemical hydration.',
    keyPoints: [
      'Extreme compressive strength, negligible tensile strength.',
      'Curing relies on retained moisture, not just "drying out".',
    ],
    types: ['PCC', 'RCC', 'Pre-stressed', 'Lightweight'],
    thumbRules: [
      'Standard M20 mix ratio is roughly 1:1.5:3 (Cement:Sand:Aggregate).',
      'Weight of 1 cubic meter of plain concrete ≈ 2400 kg; RCC ≈ 2500 kg.',
    ],
    relatedTopics: ['Water Cement Ratio', 'Curing', 'Slump Test'],
    keywords: ['concrete', 'cement', 'rock', 'pcc', 'rcc', 'aggregate'],
    siteTip:
        'Dropping concrete from a height exceeding 1.5 meters causes rapid segregation; heavy rocks fall first, paste stays on top, ruining the structural integrity.',
  ),
  'steel reinforcement': const KnowledgeTopic(
    id: 'steel reinforcement',
    title: 'Steel Reinforcement (Rebar)',
    definition:
        'Deformed bars providing the critical tension resistance that concrete naturally lacks.',
    keyPoints: [
      'Deformations (ribs) ensure a high mechanical grip/bond with the concrete paste.',
      'Thermal expansion perfectly matches concrete, preventing internal snapping.',
    ],
    types: ['Mild Steel', 'HYSD', 'TMT (Thermo-Mechanically Treated)'],
    thumbRules: [
      'Weight of steel bar per meter = D² / 162 (where D is diameter in mm).',
      'Standard manufactured bar length on site is 12 meters (40 feet).',
    ],
    relatedTopics: ['Lap Splice', 'Cover Block', 'Slab', 'Beam'],
    keywords: ['steel', 'rebar', 'tension', 'tmt', 'bar', 'iron'],
    siteTip:
        'Surface rust is acceptable and actually enhances bonding roughness. Flaking, deep-scale rust is unacceptable and must be wire-brushed off.',
  ),
  'soil mechanics': const KnowledgeTopic(
    id: 'soil mechanics',
    title: 'Soil Mechanics',
    definition:
        'The physics of analyzing earth materials, sheer strength, and settlement behavior before structural design.',
    keyPoints: [
      'Clay expands violently when wet; Sand drains quickly but washes away.',
      'Safe Bearing Capacity is derived from these tests to size footings.',
    ],
    types: ['Cohesive (Clay)', 'Cohesionless (Sand)'],
    thumbRules: [
      'Density of normal compacted soil is roughly 1600 - 1800 kg/cum.',
    ],
    relatedTopics: ['Compaction', 'Bearing Capacity'],
    keywords: ['soil', 'mechanics', 'earth', 'bearing', 'clay', 'sand', 'sbc'],
    siteTip:
        'Never trust topsoil (the dark, organic first layer). It decays over time causing massive settlement. Excavate past it entirely.',
  ),
  'bearing capacity': const KnowledgeTopic(
    id: 'bearing capacity',
    title: 'Safe Bearing Capacity (SBC)',
    definition:
        'The maximum average contact pressure between the foundation and the soil which should not produce shear failure in the soil.',
    keyPoints: [
      'Directly dictates the physical LxW dimensions of any foundation.',
      'Tested using Plate Load Tests or Standard Penetration Tests (SPT).',
    ],
    types: ['Ultimate Bearing Capacity', 'Net Safe Bearing Capacity'],
    thumbRules: ['Hard rock SBC ≈ 3300 kN/sqm. Soft clay SBC ≈ 100 kN/sqm.'],
    relatedTopics: ['Soil Mechanics', 'Foundation'],
    keywords: ['sbc', 'bearing', 'capacity', 'pressure', 'shear failure'],
    siteTip:
        'If you encounter unexpected soft pockets or old filled-in wells during footing excavation, halt work immediately. SBC assumes uniform strata.',
  ),
  'water cement ratio': const KnowledgeTopic(
    id: 'water cement ratio',
    title: 'Water-Cement Ratio (W/C)',
    definition:
        'The precise physical mass ratio of water to cement in a mix. The undisputed god of concrete strength laws.',
    keyPoints: [
      'Lower ratio = massive strength, horrible flowability.',
      'Higher ratio = super flowability, horrible strength and cracking.',
    ],
    types: ['Mix Design Parameter'],
    thumbRules: [
      'Standard acceptable W/C range is 0.40 to 0.60.',
      'Every 0.05 increase in W/C reduces compressive strength by roughy 10% to 15%.',
    ],
    relatedTopics: ['Concrete', 'Admixtures', 'Slump Test'],
    keywords: ['w/c', 'water', 'cement', 'ratio', 'strength', 'mix'],
    siteTip:
        'A transit mixer driver adding arbitrary hose-water on site to make the pour "flow faster" is actively destroying your building’s structural integrity. Stop them.',
  ),
  'admixtures': const KnowledgeTopic(
    id: 'admixtures',
    title: 'Admixtures',
    definition:
        'Chemical additions thrown into the concrete mix besides cement, water, and rocks to manipulate its natural behavior.',
    keyPoints: [
      'Can make concrete flow like water without adding actual water (Plasticizers).',
      'Can drastically slow down setting time for long-distance transit (Retarders).',
    ],
    types: ['Superplasticizers', 'Accelerators', 'Retarders', 'Air-entraining'],
    thumbRules: [
      'Dosage is usually tiny, strictly capped around 0.5% to 2% by weight of cement.',
    ],
    relatedTopics: ['Water Cement Ratio', 'Concrete'],
    keywords: [
      'chemicals',
      'plasticizer',
      'accelerator',
      'retarder',
      'admixture',
    ],
    siteTip:
        'Always request the manufacturer mix trial batches. Chemical clash between certain superplasticizers and specific local cements can cause flash-setting in the truck.',
  ),
  'masonry': const KnowledgeTopic(
    id: 'masonry',
    title: 'Masonry Construction',
    definition:
        'The systematic assembly of individual interlocking blocks or bricks, permanently fused together by a cement-sand mortar matrix.',
    keyPoints: [
      'Excels at handling direct downward compressive weight.',
      'Extremely weak at handling lateral wind or seismic snapping forces.',
    ],
    types: [
      'Burnt Clay Brickwork',
      'Concrete Block (CMU)',
      'Fly Ash Block',
      'Stone Masonry',
    ],
    thumbRules: [
      'Standard Mortar mix ratio for main load-bearing brickwork is 1:4 (Cement:Sand).',
      'For half-brick (partition) walls, the mix is usually tighter at 1:3.',
      'Bricks consume roughly 25% to 30% of standard mortar volume per cubic meter of wall.',
    ],
    relatedTopics: ['Load Distribution', 'Plastering'],
    keywords: [
      'masonry',
      'brick',
      'block',
      'cmu',
      'mortar',
      'wall',
      'assembly',
    ],
    siteTip:
        'Drop a clay brick from a height of 1-meter onto another brick. It should emit a sharp metallic clink and NOT shatter. A dull thud means it is under-baked and weak.',
  ),
  'plastering': const KnowledgeTopic(
    id: 'plastering',
    title: 'Plastering',
    definition:
        'Coating rough or uneven masonry and concrete surfaces with a plastic protective mortar layer to provide a smooth, aesthetic, waterproof finish.',
    keyPoints: [
      'Acts as the final sacrificial shield against weathering before painting.',
      'Applied via a heavy base coat followed quickly by a finer finishing layer.',
    ],
    types: ['Cement Plaster', 'Gypsum (POP)', 'Lime Plaster'],
    thumbRules: [
      'Standard thickness for internal wall plaster is 12mm.',
      'External plaster is usually thicker at 18mm to 20mm (often applied in two coats) to block rain.',
      'Ceiling plaster must never exceed 6mm to 10mm to prevent heavy ceiling spalling/falling over time.',
    ],
    relatedTopics: ['Masonry', 'Curing'],
    keywords: [
      'plastering',
      'render',
      'finish',
      'coat',
      'gypsum',
      'pop',
      'thickness',
    ],
    siteTip:
        'For RCC column surfaces meeting brickwork walls, strictly staple Chicken Wire Mesh across the joint before plastering. Due to differential expansion, that exact line will ALWAYS crack without mesh.',
  ),
};
