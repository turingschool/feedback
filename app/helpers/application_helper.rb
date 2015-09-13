module ApplicationHelper

  def ratings_for(category, form)
    [
      form.radio_button(category, "strongly_disagree", :id => 'strongly_disagree'),
      form.label(category, "Strongly Disagree", :value => 'strongly_disagree'),

      form.radio_button(category, "disagree", :id => 'disagree'),
      form.label(category, "Disagree", :value => 'disagree'),

      form.radio_button(category, "neutral", :id => 'neutral'),
      form.label(category, "Neutral", :value => 'neutral'),

      form.radio_button(category, "agree", :id => 'agree'),
      form.label(category, "Agree", :value => 'agree'),

      form.radio_button(category, "strongly_agree", :id => 'strongly_agree'),
      form.label(category, "Strongly Agree", :value => 'strongly_agree')
    ].join("\n").html_safe
  end

  def bootstrap(name)
    case name
    when 'error'
      'danger'
    else
      name
    end
  end
end
