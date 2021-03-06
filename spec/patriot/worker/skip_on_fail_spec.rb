require 'init_test'

$dt = '2011-12-12'

describe "Patriot::Worker::Base #{__FILE__}" do 

  include JobStoreMatcher

  before :each do 
    @worker = Patriot::Worker::Base.new(config_for_test)
    @job    = TestEnvirionment.build_job({
        :skip_on_fail => 'true',
        :commands     => 'no_such_a_command'
      })
    @job_store = @worker.instance_variable_get(:@job_store)
    @update_id = Time.now.to_i
    @job_store.register(@update_id, [@job])
  end

  it "sholud execute a job" do
    job_entry = Patriot::JobStore::JobTicket.new(@job.job_id, @update_id)
    expect(@worker.execute_job(job_entry)).to eq Patriot::Command::ExitCode::FAILURE_SKIPPED
    expect(@job).to be_succeeded_in @job_store
    expect(@job_store.get_execution_history(@job.job_id, {:limit => 1})[0][:exit_code]).to eq Patriot::Command::ExitCode::FAILURE_SKIPPED
  end
end
