module EventsHelper

  def event_line(event)
    action = event_action(event)
    item = event_item_name(event)
    item_path = event_item_path(event)
    somebody = for_somebody(event)

    if action.match /[^assign_id_update|deadline_update]/
      "#{somebody}#{action}#{item}：#{link_to(event.title, item_path)}".html_safe
    else
      content = case action
      when /^assign_id_update$/
        assign_user_was, assign_user = event.assign_user_was, event.assign_user
        if assign_user_was 
          if assign_user then "把 #{assign_user_was.email} 的#{item}指派给 #{assign_user.email}"
          else "取消了 #{assign_user_was.email} 的#{item}"
          end
        else
          if assign_user then "给 #{assign_user.email} 指派了#{item}"
          end
        end
      when /^deadline_update$/
        deadline_was, deadline = event.deadline_was, event.deadline
        if deadline_was 
          if deadline then "将#{item}完成时间从 #{deadline_was} 修改为 #{deadline}"
          else "将#{item}完成时间从 #{deadline_was} 修改为 没有截止日期 "
          end
        else
          if deadline then "将#{item}完成时间从 没有截止日期 修改为 #{deadline}"
          end
        end
      end

      "#{content}: #{link_to(event.title, item_path)}".html_safe
    end
  end

  def event_item_name(event)
    case event.event_item_type
    when 'Todo'
      '任务'
    else
      ""
    end
  end

  def event_item_path(event)
    case event.event_item_type
    when 'Todo'
      todo_path(event.event_item_id)
    else
      ''
    end
  end

  def for_somebody(event)
    case event.event
    when /^create$/
      assign_user = event.assign_user
      "为 #{assign_user.email}" if assign_user
    else ""
    end
  end 

  def event_action(event)
    case event.event
    when /^create$/ 
      event.commentable? ? '回复了' : '创建了'
    when /^destroy$/ then '删除了'
    when /^start!$/ then '开始处理这条'
    when /^stop!$/ then '暂停处理这条'
    when /^close!$/ then '完成了'
    when /^reopen!$/ then '重新打开了'
    else event.event
    end
  end
end
