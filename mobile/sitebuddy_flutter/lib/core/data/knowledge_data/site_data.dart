import 'package:site_buddy/shared/domain/models/knowledge_topic.dart';

final Map<String, KnowledgeTopic> siteKnowledge = {
  'piling': const KnowledgeTopic(
    id: 'piling',
    title: 'Piling',
    definition:
        'The physical driving or boring of deep vertical columns of concrete, steel, or timber deep into the earth.',
    keyPoints: [
      'Bored piles have soil excavated first, then steel inserted, then poured.',
      'Driven piles are precast and hammered violently into the ground.',
    ],
    types: ['End Bearing Pile', 'Friction Pile', 'Sheet Pile'],
    thumbRules: [
      'For a bored cast-in-situ pile, allow the tremie pipe to be embedded at least 1-2 meters into the wet concrete to prevent soil-mixing.',
    ],
    relatedTopics: ['Deep Foundation', 'Tremie Pour'],
    keywords: ['piling', 'rig', 'driven', 'bored', 'friction', 'end-bearing'],
    siteTip:
        'Always chisel down the top 1 meter of a bored pile after it cures (Pile Head Breaking) to remove the contaminated/muddy top concrete layer before casting the pile cap.',
  ),
  'compaction': const KnowledgeTopic(
    id: 'compaction',
    title: 'Soil Compaction',
    definition:
        'Mechanically forcing soil particles closer together, expelling air to increase density and lock-in strength.',
    keyPoints: [
      'Prevents massive future sinking of floors or pavements.',
      'Requires watering to an Optimal Moisture Content (OMC) prior to rolling.',
    ],
    types: ['Vibratory', 'Impact (Rammer)', 'Kneading (Sheepfoot)'],
    thumbRules: [
      'Never compact soil in layers thicker than 150mm - 200mm at a time.',
      'Target at least 95% Modified Proctor density.',
    ],
    relatedTopics: ['Soil Mechanics', 'Backfill'],
    keywords: ['compaction', 'density', 'roller', 'rammer', 'omc', 'voids'],
    siteTip:
        'If the roller bounces aggressively and the soil trembles extensively like jelly, it is over-saturated (pumping). Let it dry before rolling further.',
  ),
  'backfill': const KnowledgeTopic(
    id: 'backfill',
    title: 'Backfill',
    definition:
        'The material used to refill an excavated trench or the void around a foundation once construction is complete.',
    keyPoints: [
      'Should ideally be granular/sandy material for drainage, not expanding clay.',
      'Must be compacted in strict lifts, or it acts as a water sponge wrapping the foundation.',
    ],
    types: ['Granular Fill', 'Controlled Low-Strength Material (CLSM)'],
    thumbRules: [
      'Add roughly 10% to 15% to your volume estimates to account for shrinkage during compaction.',
    ],
    relatedTopics: ['Compaction', 'Foundation', 'Retaining Wall'],
    keywords: ['backfill', 'fill', 'trench', 'void', 'granular'],
    siteTip:
        'Do not use heavy vibratory rollers right next to a freshly built retaining wall or basement. The lateral compaction forces can shatter the green concrete wall.',
  ),
  'slump test': const KnowledgeTopic(
    id: 'slump test',
    title: 'Slump Test',
    definition:
        'A visual, empirical test using an iron cone to gauge the workability and water consistency of fresh concrete batches.',
    keyPoints: [
      'Requires a standard Abrams cone, filled in 3 compacted layers of 25 rod strokes each.',
      'Quickest way to instantly reject a watery, flawed transit mixer batch.',
    ],
    types: ['True Slump', 'Zero Slump', 'Shear Slump', 'Collapse (Reject)'],
    thumbRules: [
      'Normal RCC slab/beam slump: 75mm to 100mm.',
      'Pumped concrete slump: 100mm to 150mm.',
    ],
    relatedTopics: ['Concrete', 'Water Cement Ratio'],
    keywords: ['slump', 'cone', 'workability', 'consistency', 'test'],
    siteTip:
        'Measure the slump from the highest point of the displaced center, not the sides. If the cone shears sideways completely, the mix lacks cohesion—reject it.',
  ),
  'curing': const KnowledgeTopic(
    id: 'curing',
    title: 'Concrete Curing',
    definition:
        'Deliberately trapping or applying moisture and temp-control to concrete immediately after casting to facilitate prolonged hydration.',
    keyPoints: [
      'Cement does not "dry" into rock; it hydrates. If water evaporates too fast, hydration violently stops forever.',
      'Dramatically reduces surface dusting and plastic shrinkage webbing cracks.',
    ],
    types: [
      'Ponding / Wet Gummy Bags',
      'Curing Compounds (Chemical spray)',
      'Steam Curing',
    ],
    thumbRules: [
      'Minimum curing duration: 7 to 10 days for standard OPC cement.',
      'Strength reaches 50% in 3 days, 65% in 7 days, 99% in 28 days under proper curing.',
    ],
    relatedTopics: ['Concrete', 'Formwork'],
    keywords: [
      'curing',
      'water',
      'hydration',
      'ponding',
      'moisture',
      'strength',
    ],
    siteTip:
        'For slabs, construct tiny mud or mortar ridges (ponding) and flood them with 1-2 inches of water. It is infinitely superior to occasional hose spraying.',
  ),
  'formwork': const KnowledgeTopic(
    id: 'formwork',
    title: 'Formwork (Shuttering)',
    definition:
        'The temporary structural molds constructed to contain poured wet concrete until it hardens enough to support itself.',
    keyPoints: [
      'Must be violently rigid to resist the massive hydrostatic blowout pressure of wet concrete.',
      'Defective formwork causes bulging beams, honeycomb concrete, or lethal collapses.',
    ],
    types: ['Timber / Plywood', 'Steel Pans', 'Aluminium (Mivan)', 'Plastic'],
    thumbRules: [
      'Stripping time for vertical column forms: 16 to 24 hours.',
      'Stripping time for beam soffits (props left intact under): 7 days.',
      'Total removal of props for slabs spanning over 4.5m: 14 days.',
    ],
    relatedTopics: ['Concrete', 'Slab', 'Column'],
    keywords: ['formwork', 'shuttering', 'mold', 'strip', 'stripping', 'props'],
    siteTip:
        'Always coat the inner faces thoroughly with shuttering oil (release agent) BEFORE tying the steel rebars. Oiling after steel is in place contaminates the rebars and kills the bond.',
  ),
  'lap splice': const KnowledgeTopic(
    id: 'lap splice',
    title: 'Lap Splice (Lapping)',
    definition:
        'The overlapping of two separate steel modifier rebars side-by-side to transfer stress continuously when a single bar isn’t long enough.',
    keyPoints: [
      'Relies entirely on the concrete gripping both bars to transfer load between them.',
      'Bars should ideally be staggered so not all splices occur at the exact same critical cross-section.',
    ],
    types: [
      'Contact Lap',
      'Non-contact Lap',
      'Mechanical Coupler',
      'Welded Splice',
    ],
    thumbRules: [
      'Compression lap length is generally 40 × Bar Diameter (40d).',
      'Tension lap length is generally 50 × Bar Diameter (50d).',
      'Lapping is absolutely prohibited for bars larger than 36mm diameter; mechanical couplers must be used.',
    ],
    relatedTopics: ['Steel Reinforcement', 'Beam', 'Column'],
    keywords: [
      'lap',
      'splice',
      'overlap',
      'stagger',
      'coupler',
      'joint',
      'length',
    ],
    siteTip:
        'Never lap beam bottom tension steel exactly in the middle of a room span where bending is highest. Lap it near the supporting columns instead.',
  ),
  'cover block': const KnowledgeTopic(
    id: 'cover block',
    title: 'Clear Cover (Cover Blocks)',
    definition:
        'Minimal distance between the absolute outer edge of the concrete and the closest embedded steel reinforcement piece.',
    keyPoints: [
      'Maintained physically by tying small precast concrete biscuits or plastic wheels (Cover Blocks) to the steel cage.',
      'Acts as the primary fire protection and anti-corrosion barrier for the steel core.',
    ],
    types: ['Concrete Block', 'PVC Wheel', 'Steel Chairs (Internal)'],
    thumbRules: [
      'Standard Clear Covers: Slabs = 20mm.',
      'Beams = 25mm to 30mm.',
      'Columns = 40mm.',
      'Footings (Resting on earth) = 50mm to 75mm.',
    ],
    relatedTopics: ['Steel Reinforcement', 'Footing', 'Column'],
    keywords: [
      'cover',
      'block',
      'clear cover',
      'fire protection',
      'corrosion',
      'biscuit',
    ],
    siteTip:
        'Using brick bats or wood scraps as cover blocks is amateur and destructive. Wood rots and expands; bricks absorb water and transfer it directly to the steel.',
  ),
  'surveying': const KnowledgeTopic(
    id: 'surveying',
    title: 'Surveying',
    definition:
        'The mathematical science of determining terrestrial 3D spatial positions, establishing the cardinal grid orientation of the entire superstructure.',
    keyPoints: [
      'Generates topographic layouts, property boundaries, and critical foundation corner alignments (setting out).',
      'Uses highly calibrated optic/laser instruments (Total Stations, Dumpy Levels, Theodolites).',
    ],
    types: [
      'Topographic',
      'Cadastral (Boundary)',
      'Engineering/Construction Setting Out',
    ],
    thumbRules: [
      'Always establish at least three permanent TBMs (Temporary Bench Marks) far away from excavator tracks.',
    ],
    relatedTopics: ['Leveling', 'Layouts'],
    keywords: [
      'surveying',
      'grid',
      'total station',
      'theodolite',
      'boundary',
      'setting out',
      'topography',
    ],
    siteTip:
        'Check the surveyor’s established diagonals! If corner-to-corner lengths of a rectangular floor plan are not flawlessly identical, the entire multi-million dollar building is a parallelogram.',
  ),
  'leveling': const KnowledgeTopic(
    id: 'leveling',
    title: 'Leveling',
    definition:
        'A specific physical surveying operation calculating relative height elevations between points to establish slopes or pure flatness.',
    keyPoints: [
      'Identifies the crucial +/- gradients for plumbing networks and surface drainage.',
      'Tied definitively to a master Mean Sea Level (MSL) or an arbitrary localized 100.0m datum point.',
    ],
    types: ['Differential Leveling', 'Profile Leveling', 'Fly Leveling'],
    thumbRules: [
      'Water seeks absolute true level. Basic water-tube levels are perfectly accurate for short interior spans if absolutely zero air bubbles are present.',
    ],
    relatedTopics: ['Surveying', 'Plumbing'],
    keywords: [
      'leveling',
      'elevation',
      'gradient',
      'slope',
      'datum',
      'msl',
      'dumpy',
    ],
    siteTip:
        'When moving the theodolite/auto-level instrument, always secure the pendulum lock if it has one. Throwing it carelessly into a truck bed shatters the high-precision internal compensator.',
  ),
  'scaffolding': const KnowledgeTopic(
    id: 'scaffolding',
    title: 'Scaffolding',
    definition:
        'Interlocking temporary framework erected externally to support labor crews and material drops high in the air safely.',
    keyPoints: [
      'A critical safety asset heavily regulated by OSHA and civil codes.',
      'Must withstand extreme wind-loading (sail effect) when wrapped with safety netting.',
    ],
    types: [
      'Cuplock',
      'Tube & Coupler',
      'Suspended Platform (Gondola)',
      'Mobile Tower',
    ],
    thumbRules: [
      'Standard working platform width should never be less than 600mm (three standard planks).',
      'Tie-ins rigidly locking the scaffold to the main building should be placed at least every 4 meters vertically and horizontally.',
    ],
    relatedTopics: ['Formwork'],
    keywords: [
      'scaffolding',
      'framework',
      'working platform',
      'cuplock',
      'safety',
      'guardrail',
    ],
    siteTip:
        'Inspect the base plates daily. A beautiful 10-story scaffold will collapse entirely if rain washes away the mud beneath just one un-plated base pole.',
  ),
  'excavation': const KnowledgeTopic(
    id: 'excavation',
    title: 'Excavation & Trenching',
    definition:
        'The aggressive removal of mass earth/rock segments to establish a subterranean footprint or utility highway.',
    keyPoints: [
      'Trenching is statistically one of the absolute deadliest construction operations due to silent, instant soil wall collapse.',
      'Requires intensive pre-planning for massive displaced dirt management (spoil).',
    ],
    types: [
      'Bulk Basement Excavation',
      'Trenching',
      'Dredging',
      'Rock Blasting',
    ],
    thumbRules: [
      'Any trench deeper than 1.5 meters (5 feet) MUST be sloped, benched, or heavily shored continuously.',
      'Spoil piles must be kept back a minimum of 0.6 meters (2 feet) from the edge of the pit to prevent surcharge collapse.',
    ],
    relatedTopics: ['Shoring', 'Soil Mechanics', 'Backfill'],
    keywords: [
      'excavation',
      'digging',
      'trenching',
      'spoil',
      'collapse',
      'pit',
      'earth moving',
    ],
    siteTip:
        'When excavating near property lines, constantly monitor neighbors\' boundary walls for hairline cracks daily. Undermining their foundation happens silently right until their wall falls into your pit.',
  ),
  'shoring': const KnowledgeTopic(
    id: 'shoring',
    title: 'Shoring & Shielding',
    definition:
        'Heavy-duty engineered temporary support installed to prevent the collapse of excavated earth walls or unstable adjacent superstructures.',
    keyPoints: [
      'Used extensively when site constraints prevent safe angled sloping of dirt walls.',
      'Shields (Trench Boxes) do not prevent collapse; they merely protect the worker inside if a collapse occurs.',
    ],
    types: [
      'Timber Shoring',
      'Hydraulic Rams',
      'Sheet Pile Walls',
      'Soldier Piles',
    ],
    thumbRules: [
      'Walers (horizontal support beams) must be placed directly opposite the highest calculated soil pressure zones based on the specific soil type.',
    ],
    relatedTopics: ['Excavation', 'Retaining Wall'],
    keywords: [
      'shoring',
      'shielding',
      'struts',
      'trench box',
      'support',
      'collapse prevention',
    ],
    siteTip:
        'Do not remove bottom shoring struts to "make room for the pipe". It immediately redistributes thousands of tons of dirt pressure onto the remaining jacks, snapping them instantly.',
  ),
};
