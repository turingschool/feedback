class GroupingsController < ApplicationController
  def show
    @grouping = Grouping.find_by(tag: params[:id])
  end

  def edit
    @grouping = Grouping.find_by(tag: params[:id])
  end

  def update
    grouping = Grouping.find_by(id: params[:id])
    grouping.update_attributes(content: params[:content])
    render text: grouping.content
  end
end
