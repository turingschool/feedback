module ApplicationHelper

  def ratings_for(category, form)
   [form.radio_button(category, "strongly_disagree", :id => 'strongly_disagree'),
    form.label(category, "Strongly Disagree"),

    form.radio_button(category, "disagree", :id => 'disagree'),
    form.label(category, "Disagree"),

    form.radio_button(category, "neutral", :id => 'neutral'),
    form.label(category, "Neutral"),

    form.radio_button(category, "agree", :id => 'agree'),
    form.label(category, "Agree"),

    form.radio_button(category, "strongly_agree", :id => 'strongly_agree'),
    form.label(category, "Strongly Agree")].join("\n").html_safe
  end
end
