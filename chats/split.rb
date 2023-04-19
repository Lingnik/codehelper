filename = ARGV[0]
num_parts = ARGV[1].to_i
file_size = File.size(filename)

chunk_size = (file_size.to_f / num_parts).ceil

File.open(filename, "r") do |file|
  1.upto(num_parts) do |i|
    output_filename = "#{filename}.part#{i}"
    File.open(output_filename, "w") do |output_file|
      output_file.write(file.read(chunk_size))
    end
    token_estimator_output = `python ../util/token_estimator.py ./#{output_filename}`
    puts token_estimator_output
  end
end
