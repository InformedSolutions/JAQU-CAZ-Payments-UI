# frozen_string_literal: true

# Reads provided file from +spec/fixtures/files+ directory
def read_file(filename)
  JSON.parse(File.read("spec/fixtures/files/#{filename}"))
end
