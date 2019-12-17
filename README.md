# AasmParser

## Usage

### define aasm class(aasm 5.0.6)

```rb
class Task < ApplicationRecord
  include AASM

  aasm column: :status do
    state :waiting, initial: true
    state :in_progress, :pending, :finished

    event :start do
      transitions from: :waiting, to: :in_progress
      transitions from: :pending, to: :in_progress
    end

    event :stop do
      transitions from: :in_progress, to: :pending
    end

    event :finish do
      transitions from: :in_progress, to: :finished
    end
  end
end
```

### run

```
$ bundle install
$ bin/console
```

```rb
aasm = AasmParser.parse_file('./task.rb')
aasm.initial_state
# => :waiting
aasm.state_names
# => [:waiting, :in_progress, :pending, :finished]
aasm.events.map(&:name)
# => [:start, :stop, :finish]
aasm.events.flat_map(&:transitions).map { |e| "#{e.from} => #{e.to}" }
# => ["waiting => in_progress", "pending => in_progress", "in_progress => pending", "in_progress => finished"]
```
