class Teams::TeamSerializer < ApplicationSerializer
  def as_json(options ={})
    {
      id: id,
      description: description,
      name: name,
      team_members: get_members,
      manager: manager,
    }
  end

  private

  def get_members
    team_members.map do |team_member|
      {
        id: team_member.id,
        member_name: team_member.user.name,
        role: team_member.role,
        path: team_team_member_path(self, team_member)
      }
    end
  end
end
