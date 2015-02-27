json.array!(@switch_models) do |switch_model|
  json.extract! switch_model, :id, :name
  json.url switch_model_url(switch_model, format: :json)
end
