class JobsController < ApplicationController
  def new; end

  def create
    pipeline = TriggerCircleCiJobsService.new(permitted_params).run_pipeline
    json_pipeline = JSON.parse(pipeline)

    redirect_to action: :new, state: json_pipeline['state'], id: json_pipeline['id']
  end

  def permitted_params
    params.permit!
  end
end
