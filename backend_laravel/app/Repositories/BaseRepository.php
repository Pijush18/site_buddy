<?php

namespace App\Repositories;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Collection;

/**
 * Base Repository
 * Handles common database interactions
 */
abstract class BaseRepository
{
    protected $model;

    /**
     * BaseRepository constructor.
     * @param Model $model
     */
    public function __construct(Model $model)
    {
        $this->model = $model;
    }

    /**
     * Get all records
     */
    public function all(): Collection
    {
        return $this->model->all();
    }

    /**
     * Find record by ID
     */
    public function find(int $id): ?Model
    {
        return $this->model->find($id);
    }

    /**
     * Create new record
     */
    public function create(array $data): Model
    {
        return $this->model->create($data);
    }

    /**
     * Update record
     */
    public function update(int $id, array $data): bool
    {
        $record = $this->find($id);
        if (!$record) return false;
        return $record->update($data);
    }

    /**
     * Delete record
     */
    public function delete(int $id): bool
    {
        $record = $this->find($id);
        if (!$record) return false;
        return $record->delete();
    }
}
