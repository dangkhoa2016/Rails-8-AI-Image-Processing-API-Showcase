# frozen_string_literal: true

require "fileutils"
require "digest"

root = File.expand_path("..", __dir__)
site = File.join(root, "site")
assets = File.join(site, "assets")
outputs = File.join(root, "assets", "output")
inputs = File.join(root, "assets", "input")
index_path = File.join(site, "index.html")

mapping = {
  File.join(inputs, "person-smiling-cc0-1280.jpg") => File.join(assets, "person-input.jpg"),
  File.join(outputs, "person-soft-background.png") => File.join(assets, "person-soft-background.png"),
  File.join(outputs, "person-box-mask.png") => File.join(assets, "person-box-mask.png"),
  File.join(inputs, "dog-puppy-white-cc0-1280.jpg") => File.join(assets, "dog-input.jpg"),
  File.join(outputs, "dog-point-mask.png") => File.join(assets, "dog-point-mask.png"),
  File.join(outputs, "dog-box-mask.png") => File.join(assets, "dog-box-mask.png"),
  File.join(outputs, "dog-point-selection.webp") => File.join(assets, "dog-point-selection.webp"),
  File.join(outputs, "dog-box-selection.webp") => File.join(assets, "dog-box-selection.webp"),
  File.join(inputs, "horse-white-cc0-1280.jpg") => File.join(assets, "horse-input.jpg"),
  File.join(outputs, "horse-point-mask.png") => File.join(assets, "horse-point-mask.png"),
  File.join(outputs, "horse-box-mask.png") => File.join(assets, "horse-box-mask.png"),
  File.join(outputs, "horse-point-selection.webp") => File.join(assets, "horse-point-selection.webp"),
  File.join(outputs, "horse-box-selection.webp") => File.join(assets, "horse-box-selection.webp")
}

missing = mapping.keys.reject { |path| File.file?(path) && File.size(path).positive? }
abort "Missing showcase outputs: #{missing.join(", ")}" unless missing.empty?

FileUtils.mkdir_p(assets)
mapping.each { |src, dst| FileUtils.cp(src, dst) }

# The bilingual showcase copy is maintained directly in site/index.html.
# This installer only refreshes generated assets and integrity metadata so reruns
# cannot overwrite curated EN/VI content.

files = Dir.glob(File.join(assets, "*")).select { |p| File.file?(p) }.sort
File.open(File.join(site, "SHA256SUMS"), "w") do |f|
  files.each { |p| f.puts "#{Digest::SHA256.file(p).hexdigest}  assets/#{File.basename(p)}" }
end

puts "PEOPLE_ANIMALS_INSTALL=PASS"
puts "ASSETS=#{mapping.length}"
