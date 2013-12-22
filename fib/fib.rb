require "benchmark"

# Basic recursive fibonacci O(2^n)
def recurse_fib(n)
  return n if n <= 1 
  recurse_fib(n - 2) + recurse_fib(n - 1)
end

# Recursive fibonacci with a dab of caching O(n)
def cached_fib(n, h = {})
  if cached = h[n] 
    return cached
  end

  return h[n] = n if n <= 1

  h[n] = cached_fib(n - 2, h) + cached_fib(n - 1, h)
end

# Iteration O(n)
def iterative_fib(n)
  return n if n <= 1 

  fib, fib_prev = 1, 0

  (n - 1).times do
    fib, fib_prev = fib + fib_prev, fib
  end

  fib
end

if __FILE__ == $0
  puts "Checking versions up to 30"

  (0..20).each do |n|
    recurse   = recurse_fib(n)
    cached    = cached_fib(n)
    iterative = iterative_fib(n)

    if recurse == cached && cached == iterative
      print "#{recurse} "
    else
      puts "#{n} is not the same:"
      puts "recurse #{recurse}"
      puts "cached #{cached}"
      puts "iterative #{iterative}"
    end
  end

  puts

  Benchmark.bmbm do |x|
    num = 40

    x.report "Recursive" do
      recurse_fib(num)
    end

    x.report "Cached Recursive" do
      cached_fib(num)
    end
  
    x.report "Iterative" do
      iterative_fib(num)
    end
  end
end
