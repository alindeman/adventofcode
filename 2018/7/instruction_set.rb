require "set"

class InstructionSet
  def initialize
    @dependencies = Hash.new { |h, k| h[k] = Set.new }
    @steps = Set.new
  end

  def add_rule(step, dependency)
    @dependencies[step] << dependency

    @steps << step
    @steps << dependency
  end

  def each
    return enum_for(:each) unless block_given?

    ready = ready_given(Set.new)
    steps_completed = Set.new
    until ready.empty?
      step = ready.first
      ready.delete(step)

      steps_completed.add(step)
      yield step

      ready = ready.union(ready_given(steps_completed))
    end
  end

  def to_s
    each.to_a.join
  end

  def ready_given(steps_completed)
    SortedSet.new(
      @steps.select { |s|
        !steps_completed.include?(s) && \
          steps_completed.superset?(@dependencies[s])
      }
    )
  end

  def total_time(workers: 5, base_time: 60)
    time = 0
    ready = SortedSet.new
    steps_completed = Set.new
    steps_in_progress = Set.new
    workers = Array.new(workers)
    loop do
      workers.each_with_index do |worker, i|
        next if worker.nil?

        if time >= worker[:finished_at]
          steps_in_progress.delete(worker[:step])
          steps_completed.add(worker[:step])
          workers[i] = nil
        end
      end

      break if steps_completed.length == @steps.length

      ready = ready.
        union(ready_given(steps_completed)).
        difference(steps_in_progress)

      # Try to give the work to a worker
      ready.each do |step|
        free_worker_with_index = workers.
          each_with_index.
          detect { |worker, i| worker.nil? }

        break if free_worker_with_index.nil? # can't assign any more work

        workers[free_worker_with_index.last] = {
          step: step,
          finished_at: time + work_required(step, base_time: base_time),
        }
        steps_in_progress.add(step)
      end
      ready = ready.difference(steps_in_progress)

      # print "#{time}\t"
      # workers.each do |worker|
      #   print "#{worker&.fetch(:step)}\t"
      # end
      # puts

      time += 1
    end

    time
  end

  def work_required(step, base_time:)
    base_time + (step.ord - "A".ord) + 1
  end
end

