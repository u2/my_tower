json.array!(@accesses) do |access|
  json.extract! access, :id, :user_id, :project_id, :team_id, :role
  json.url access_url(access, format: :json)
end
