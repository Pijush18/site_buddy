import 'package:site_buddy/shared/domain/models/knowledge_topic.dart';

final Map<String, KnowledgeTopic> structuralKnowledge = {
  'slab': const KnowledgeTopic(
    id: 'slab',
    title: 'Slab',
    definition:
        'A flat, horizontal structural element used in floors and roof decks to transfer loads to supporting beams, columns, or walls.',
    keyPoints: [
      'Transfers active floor loads to intermediate beams.',
      'Typically spans between 3 to 6 meters in residential buildings.',
      'Designed to resist bending moments and shear forces.',
    ],
    types: [
      'One-way Slab',
      'Two-way Slab',
      'Cantilever Slab',
      'Flat Slab',
      'Waffle Slab',
    ],
    thumbRules: [
      'Thickness ≈ span (ft) in cm (e.g., 12 ft span ≈ 12 cm or 120 mm minimum).',
      'Cantilever thickness ≈ span / 10 for safe deflection limits.',
      'Minimum steel reinforcement for mild steel is 0.15% of gross cross-sectional area.',
    ],
    relatedTopics: ['Beam', 'Column', 'Load Distribution', 'Reinforcement'],
    keywords: [
      'slab',
      'floor',
      'roof',
      'one-way',
      'two-way',
      'cantilever',
      'thickness',
      'span',
    ],
    siteTip:
        'Ensure proper chair placement underneath continuous top reinforcement mesh. Stepping on the mesh crushes it to the bottom, rendering the negative moment steel useless.',
  ),
  'beam': const KnowledgeTopic(
    id: 'beam',
    title: 'Beam',
    definition:
        'A horizontal structural element primarily resisting lateral loads (bending). Beams transfer slab loads down into the vertical columns.',
    keyPoints: [
      'Tension occurs at the bottom (requiring steel), while compression happens at the top.',
      'Continuous beams span over multiple supports, reducing mid-span moments.',
      'Shear links (stirrups) are densest near the supports (columns) where shear stress is highest.',
    ],
    types: [
      'Simply Supported',
      'Continuous',
      'Cantilever',
      'Fixed',
      'Overhanging',
    ],
    thumbRules: [
      'Depth = span (m) × (7 to 8 cm) (e.g., 6m span ≈ 420mm to 480mm deep).',
      'Width ≈ 1/2 to 2/3 of the depth (e.g., 450mm deep ≈ 230mm wide).',
      'Minimum longitudinal bars: 2 on top, 2 on bottom.',
    ],
    relatedTopics: ['Slab', 'Column', 'Load Distribution', 'Shear'],
    keywords: [
      'beam',
      'strut',
      'girder',
      'bending',
      'stirrups',
      'depth',
      'width',
      'size',
    ],
    siteTip:
        'Strictly check lap splice locations. Never splice bottom tension bars in the middle of a beam span; splice them near the supports instead.',
  ),
  'column': const KnowledgeTopic(
    id: 'column',
    title: 'Column',
    definition:
        'A rigorous vertical structural element responsible for carrying compressive axial loads from beams and slabs down to the foundation.',
    keyPoints: [
      'Maintains the lateral stability of the overall framework.',
      'Failure in a column is catastrophic, causing global collapse, unlike a localized slab failure.',
      'Lateral ties confine the concrete core, significantly boosting load capacity and ductility.',
    ],
    types: [
      'Tied Column',
      'Spiral Column',
      'Composite Column',
      'Short Column',
      'Long/Slender Column',
    ],
    thumbRules: [
      'Standard minimum size: 9" x 9" (230mm x 230mm) for single-story (avoid less).',
      'Longitudinal steel should be between 0.8% and 6% of the gross cross-sectional area.',
      'Clear cover must be strictly 40mm minimum to protect the primary vertical steel.',
    ],
    relatedTopics: ['Beam', 'Foundation', 'Footing', 'Load Distribution'],
    keywords: [
      'column',
      'pillar',
      'vertical',
      'compression',
      'buckling',
      'ties',
      'slender',
    ],
    siteTip:
        'Use a plumb bob to guarantee absolute verticality (plumb) before and during the concrete pour. A column leaning even 1 inch significantly induces accidental bending moments.',
  ),
  'footing': const KnowledgeTopic(
    id: 'footing',
    title: 'Footing',
    definition:
        'The expanded base of a column or wall that sits directly on the earth, safely distributing upper structural weight across a wider area of soil.',
    keyPoints: [
      'Must rest on virgin, undisturbed soil with adequate bearing capacity, never placed on loose backfill.',
      'A sub-layer of plain cement concrete (PCC) is always poured to provide a clean, level working surface.',
      'Depth depends on reaching firm strata and staying beneath the local frost line.',
    ],
    types: [
      'Isolated Pad Footing',
      'Combined Footing',
      'Strip/Wall Footing',
      'Strap Footing',
    ],
    thumbRules: [
      'Minimum depth of footing below Natural Ground Level (NGL) should be 1.5 meters.',
      'Minimum thickness at the edges for an isolated pad should not be less than 150mm on resting soil.',
      'Minimum clear cover for footing reinforcement resting on earth is 50mm.',
    ],
    relatedTopics: ['Foundation', 'Column', 'Soil Mechanics'],
    keywords: [
      'footing',
      'pad',
      'combined',
      'strip',
      'base',
      'spread',
      'cover',
    ],
    siteTip:
        'Keep footing pits completely de-watered during pouring. Throwing dry cement indiscriminately into a muddy pit permanently ruins the water-cement ratio and foundation strength.',
  ),
  'foundation': const KnowledgeTopic(
    id: 'foundation',
    title: 'Foundation',
    definition:
        'The lowest engineered division of a superstructure, typically below ground level, responsible for transferring all structural building weight into the earth.',
    keyPoints: [
      'Prevents uneven or differential structural settlement.',
      'Divided broadly into Shallow (surface resting) and Deep (friction or bedrock resting) categories.',
      'Must withstand entirely unpredictable lateral soil movements and seismic tremors.',
    ],
    types: ['Shallow Foundation', 'Deep Foundation', 'Machine Foundation'],
    thumbRules: [
      'Foundation footprint area = Total Load / Safe Bearing Capacity (SBC) of soil.',
      'Ensure a 1 meter operational gap around the foundation perimeter for construction workspace and backfilling.',
    ],
    relatedTopics: [
      'Footing',
      'Shallow Foundation',
      'Deep Foundation',
      'Soil Mechanics',
    ],
    keywords: [
      'foundation',
      'base',
      'basement',
      'shallow',
      'deep',
      'settlement',
      'load',
    ],
    siteTip:
        'Perform a core penetration or standard penetration test (SPT) before designing. Never guess Safe Bearing Capacity; a bad guess guarantees structural failure.',
  ),
  'load distribution': const KnowledgeTopic(
    id: 'load distribution',
    title: 'Load Distribution Path',
    definition:
        'The sequential transfer of gravitational and lateral forces through the interconnected skeleton of a structural framework until it dissipates into the ground.',
    keyPoints: [
      'The primary path: Slab → Beam → Column → Footing → Earth.',
      'Gravity loads (Dead/Live) flow strictly downwards.',
      'Lateral loads (Wind/Seismic) induce sheer and bending forces requiring horizontal bracing or shear walls.',
    ],
    types: ['Gravity Load Path', 'Lateral Load Path', 'Tributary Area Method'],
    thumbRules: [
      'Slab dead load ≈ 2.4 kN/sqm per 100mm of concrete thickness.',
      'Live load for standard residential slabs ≈ 2.0 to 3.0 kN/sqm.',
      'Brick wall load on a beam ≈ 18 kN/cum to 20 kN/cum of brickwork volume.',
    ],
    relatedTopics: ['Slab', 'Beam', 'Column', 'Foundation'],
    keywords: [
      'load',
      'distribution',
      'path',
      'tributary',
      'gravity',
      'transfer',
      'dead load',
      'live load',
    ],
    siteTip:
        'Unplanned, heavy localized loads (like moving a multi-ton water tank onto a mid-span slab) breaks the intended path. Always position heavy equipment directly over column supports.',
  ),
  'shallow foundation': const KnowledgeTopic(
    id: 'shallow foundation',
    title: 'Shallow Foundation',
    definition:
        'A foundation that transfers building loads to the earth very near the surface, usually where depth is less than width.',
    keyPoints: [
      'Economical for low-rise buildings with good hard strata near the surface.',
      'Highly susceptible to scour from aggressive surface water runoff or frost heave.',
    ],
    types: ['Isolated', 'Combined', 'Strip', 'Raft (Mat)'],
    thumbRules: [
      'Depth of foundation = (Safe Bearing Capacity / Density of soil) × [ (1-sinΦ)/(1+sinΦ) ]² (Rankine’s formula).',
    ],
    relatedTopics: ['Foundation', 'Footing', 'Raft Foundation'],
    keywords: ['shallow', 'surface', 'footing', 'mat', 'scour'],
    siteTip:
        'Ensure the bottom is bone dry. Even a minor layer of loose mud turns into a sliding paste under building weight.',
  ),
  'deep foundation': const KnowledgeTopic(
    id: 'deep foundation',
    title: 'Deep Foundation',
    definition:
        'A foundation transferring loads far below the surface, piercing weak soil to reach bedrock or utilizing immense skin friction.',
    keyPoints: [
      'Essential for skyscrapers, bridge piers, or structures over marsh/marine clay.',
      'Installed using heavy piling rigs (bored or driven).',
    ],
    types: ['Pile', 'Pier', 'Caisson'],
    thumbRules: [
      'Spacing between friction piles should be minimum 3 times the pile diameter.',
    ],
    relatedTopics: ['Foundation', 'Piling'],
    keywords: ['deep', 'pile', 'rig', 'bedrock', 'friction', 'pier'],
    siteTip:
        'If driving a pile hitting early refusal (stops moving), do not over-hammer. It will shatter the concrete pile underground.',
  ),
  'raft foundation': const KnowledgeTopic(
    id: 'raft foundation',
    title: 'Raft Foundation (Mat)',
    definition:
        'A thick continuous concrete slab resting on a large area of soil lined with steel, supporting multiple columns and walls.',
    keyPoints: [
      'Used when soil SBC is very low and individual footings would overlap.',
      'Effectively bridges over erratic, soft soil patches to minimize dangerous differential settlement.',
    ],
    types: ['Flat Plate', 'Plate with Drops', 'Ribbed Raft'],
    thumbRules: [
      'Recommended if total isolated footing area exceeds 50% of the entire building footprint area.',
    ],
    relatedTopics: ['Shallow Foundation', 'Slab', 'Load Distribution'],
    keywords: ['raft', 'mat', 'continuous slab', 'differential settlement'],
    siteTip:
        'Pouring a massive raft requires a continuous, calculated concrete supply. Missing a supply truck can cause a cold joint, splitting the raft permanently.',
  ),
  'retaining wall': const KnowledgeTopic(
    id: 'retaining wall',
    title: 'Retaining Wall',
    definition:
        'A heavy rigid structure constructed to perpetually hold back massive horizontal lateral earth pressures from sliding.',
    keyPoints: [
      'Hydrostatic water buildup behind the wall is its greatest enemy, drastically multiplying lateral collapse pressure.',
      'Strictly requires continuous drainage pathways via weeping systems.',
    ],
    types: ['Gravity Wall', 'Cantilever Wall', 'Sheet Piling', 'Gabion Basket'],
    thumbRules: [
      'The base width of a cantilever retaining wall is roughly 0.5 to 0.7 times the height of the wall.',
      'Provide PVC weep holes at 1 to 1.5-meter staggered intervals horizontally and vertically.',
    ],
    relatedTopics: ['Backfill', 'Load Distribution'],
    keywords: [
      'retaining',
      'wall',
      'lateral',
      'earth pressure',
      'weep hole',
      'drainage',
      'cantilever',
    ],
    siteTip:
        'Wrap the backside (earth side) of weep holes heavily with geotextile fabric and gravel. Otherwise, fine clay clogs the pipes in a week, turning the wall into a ticking dam.',
  ),
  'shear': const KnowledgeTopic(
    id: 'shear',
    title: 'Shear Force',
    definition:
        'An unaligned structural tearing force pushing one part of a body in one direction, and another part in the opposite direction.',
    keyPoints: [
      'In beams, shear causes catastrophic diagonal cracking near the column supports.',
      'Counteracted primarily by wrapping the internal cage in tightly spaced closed loops called Stirrups (or Ties in columns).',
    ],
    types: ['One-way Shear', 'Two-way Shear (Punching Shear)'],
    thumbRules: [
      'Spacing of stirrups is always tighter (closer together) near the column supports and wider at the center of the beam span.',
    ],
    relatedTopics: ['Beam', 'Punching Shear', 'Stirrups'],
    keywords: [
      'shear',
      'force',
      'tearing',
      'diagonal crack',
      'stirrups',
      'ties',
    ],
    siteTip:
        'Ensure the hooks of the stirrups are bent to a full 135 degrees, tucking into the concrete core. 90-degree outer bends simply pop open under severe earthquake shear.',
  ),
  'punching shear': const KnowledgeTopic(
    id: 'punching shear',
    title: 'Punching Shear (Two-Way)',
    definition:
        'A concentrated shear force that causes a heavily loaded column to physically punch a hole straight through a flat slab or footing base.',
    keyPoints: [
      'The most critical failure check for Flat Slabs (slabs lacking intermediary beams).',
      'Resisted by increasing local slab thickness (Drop Panels) or widening the column head (Capitals).',
    ],
    types: ['Flat Slab Penetration', 'Footing Penetration'],
    thumbRules: [
      'The critical punching shear perimeter is evaluated exactly at a distance of d/2 away from the column face.',
    ],
    relatedTopics: ['Shear', 'Slab', 'Footing'],
    keywords: [
      'punching',
      'shear',
      'two-way',
      'flat slab',
      'penetration',
      'drop panel',
    ],
    siteTip:
        'If a footing excavation is flooded and poured hastily, the weakened base concrete loses shear strength, allowing the column above to punch through and sink the building.',
  ),
};
