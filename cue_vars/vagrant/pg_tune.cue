package pg_tune

let Schema = close({
  max_connections: uint
  shared_buffers: string
  effective_cache_size: string
  maintenance_work_mem: string
  checkpoint_completion_target: float
  wal_buffers: string
  default_statistics_target: uint
  random_page_cost: float
  effective_io_concurrency: uint
  work_mem: string
  min_wal_size: string
  max_wal_size: string
})

Schema & {
  max_connections: 30
  shared_buffers: "128MB"
  effective_cache_size: "200MB"
  maintenance_work_mem: "40MB"
  checkpoint_completion_target: 0.9
  wal_buffers: "5MB"
  default_statistics_target: 100
  random_page_cost: 1.1
  effective_io_concurrency: 100
  work_mem: "768kB"
  min_wal_size: "1GB"
  max_wal_size: "2GB"
}
