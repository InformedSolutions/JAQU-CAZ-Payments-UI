# frozen_string_literal: true

# Reads provided file from +spec/fixtures/files+ directory
def read_file(filename)
  JSON.parse(File.read("spec/fixtures/files/#{filename}"))
end

# Reads provided file from +spec/fixtures/files+ directory
def read_raw_file(filename)
  File.read("spec/fixtures/files/#{filename}")
end
