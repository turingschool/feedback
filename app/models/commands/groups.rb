module Commands
  class Groups < Base
    def group_size
      params["text"].split.last.to_i
    end

    def usergroup
      params["text"].split.first
    end

    def response
      return "Sorry, not a valid group size #{group_size}" unless group_size > 0

      group = Slackk.user_group_by_handle(usergroup)
      if group
        members = Slackk.user_group_members(group["id"])
        header = "Groups:"
        grouping = "* " + members.map do |uid|
          Slackk.member(uid)
        end.map do |member|
          member["name"]
        end.shuffle.each_slice(group_size).map do |pair|
          pair.join(", ")
        end.join("\n* ")

        g = Grouping.create(content: grouping)

        footer = "Stored this grouping as #{g.tag}. You can use this tag later to request feedback from these groups. View it: #{grouping_url(g)}"
        [header, grouping, footer].join("\n")
      else
        gnames = Slackk.user_groups.map { |g| g["handle"] }.join(", ")
        "Sorry, #{usergroup} is not a known usergroup. Try one of #{gnames}."
      end
    end
  end
end
