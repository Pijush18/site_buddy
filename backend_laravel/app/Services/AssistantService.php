<?php

namespace App\Services;

class AssistantService
{
    /**
     * Map of engineering keywords to intents and suggestions.
     */
    protected array $intentMap = [
        'beam' => [
            'intent' => 'beam_design',
            'suggestions' => [
                'Beam Reinforcement Design',
                'Concrete Quantity',
                'Steel Weight',
                'Cost Estimation'
            ]
        ],
        'slab' => [
            'intent' => 'slab_design',
            'suggestions' => [
                'One-way Slab Design',
                'Two-way Slab Design',
                'Concrete Quantity',
                'Steel Weight'
            ]
        ],
        'column' => [
            'intent' => 'column_design',
            'suggestions' => [
                'Column Reinforcement',
                'Concrete Quantity',
                'Steel Weight',
                'Load Analysis'
            ]
        ],
        'footing' => [
            'intent' => 'footing_design',
            'suggestions' => [
                'Isolated Footing Design',
                'Combined Footing Design',
                'Concrete Quantity',
                'Steel Weight'
            ]
        ],
        'quantity' => [
            'intent' => 'quantity_estimation',
            'suggestions' => [
                'Concrete Quantity',
                'Steel Weight',
                'Brickwork Calculation',
                'Plastering Calculation'
            ]
        ],
        'cost' => [
            'intent' => 'cost_estimation',
            'suggestions' => [
                'Project Cost Summary',
                'Material Cost Breakdown',
                'Labor Cost Estimation',
                'Total Expenditure'
            ]
        ],
    ];

    /**
     * Process the user query and detect engineering intent.
     */
    public function query(string $query): array
    {
        $normalizedQuery = strtolower($query);
        $intent = 'general_inquiry';
        $suggestions = ['Ask about beams, slabs, columns, footings, or costs.'];

        // Simple keyword detection logic
        foreach ($this->intentMap as $keyword => $data) {
            if (str_contains($normalizedQuery, $keyword)) {
                $intent = $data['intent'];
                $suggestions = $data['suggestions'];
                break;
            }
        }

        return [
            'intent' => $intent,
            'suggestions' => $suggestions,
        ];
    }
}
