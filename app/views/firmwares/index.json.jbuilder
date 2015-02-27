json.array!(@firmwares) do |firmware|
  json.extract! firmware, :id, :name, :switch_model_id
  json.url firmware_url(firmware, format: :json)
end
