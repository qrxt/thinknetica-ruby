# Общее

lint:
	rubocop --config ./.rubocop.yml

lint-fix:
	rubocop --config ./.rubocop.yml --auto-correct-all

# 1 Основы ruby. Часть 1

# 1-1
run-1-1:
	ruby ./1-basics-1/1-ideal-weight/main.rb

test-1-1:
	ruby ./1-basics-1/1-ideal-weight/ideal_weight_test.rb

# 1-2
run-1-2:
	ruby ./1-basics-1/2-triangle-square/main.rb

test-1-2:
	ruby ./1-basics-1/2-triangle-square/triangle_square_test.rb

# 1-3
run-1-3:
	ruby ./1-basics-1/3-right-triangle/main.rb

test-1-3:
	ruby ./1-basics-1/3-right-triangle/triangle_test.rb

# 1-4
run-1-4:
	ruby ./1-basics-1/4-quadratic-equation/main.rb

test-1-4:
	ruby ./1-basics-1/4-quadratic-equation/quadratic_equation_test.rb

# 2 Основы ruby. Часть 2

# 2-1
run-2-1:
	ruby ./2-basics-2/1-calendar-hash/main.rb

# 2-2
run-2-2:
	ruby ./2-basics-2/2-fill-array/main.rb

test-2-2:
	ruby ./2-basics-2/2-fill-array/fill_array_test.rb

# 2-3
run-2-3:
	ruby ./2-basics-2/3-fib/main.rb

test-2-3:
	ruby ./2-basics-2/3-fib/fib_test.rb

# 2-4
run-2-4:
	ruby ./2-basics-2/4-vowels/main.rb

test-2-4:
	ruby ./2-basics-2/4-vowels/vowels_test.rb

# 2-5
run-2-5:
	ruby ./2-basics-2/5-day-index/main.rb

test-2-5:
	ruby ./2-basics-2/5-day-index/day_index_test.rb

# 2-6
run-2-6:
	ruby ./2-basics-2/6-shopping-list/main.rb

# 3
run-3:
	ruby ./3-oop-basics/main.rb

test-3:
	ruby ./3-oop-basics/train_test.rb
	ruby ./3-oop-basics/station_test.rb
	ruby ./3-oop-basics/route_test.rb

# 4
run-4:
	irb -r ./4-oop-inheritance/main.rb

test-4:
	ruby ./4-oop-inheritance/train/train_test.rb
	ruby ./4-oop-inheritance/station/station_test.rb
	ruby ./4-oop-inheritance/route/route_test.rb
	ruby ./4-oop-inheritance/train/passenger_train_test.rb
	ruby ./4-oop-inheritance/train/cargo_train_test.rb

# 5
run-5:
	irb -r ./5-oop-object-model/main.rb

test-5:
	ruby -Itest 5-oop-object-model/tests.rb


# 6
run-6:
	irb -r ./6-exceptions/main.rb

test-6:
	ruby -Itest ./6-exceptions/tests.rb

# 7
run-7:
	irb -r ./7-blocks/main.rb

test-7:
	ruby -Itest ./7-blocks/tests.rb

# 8
run-8:
	irb -r ./8-rubocop/main.rb

test-8:
	ruby -Itest ./8-rubocop/tests.rb
