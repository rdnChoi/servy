defmodule PledgeServerTest do
  use ExUnit.Case
  alias Servy.PledgeServer

  test "Ensures Pledge Server ONLY holds 3 most recent calls" do
    PledgeServer.start([{"sadf", 10}, {"choco", 40}, {"Aguacante", 50}])

    PledgeServer.create_pledge("larry", 10)
    PledgeServer.create_pledge("moe", 20)
    PledgeServer.create_pledge("curly", 30)
    PledgeServer.create_pledge("daisy", 40)
    PledgeServer.create_pledge("grace", 50)

    assert PledgeServer.recent_pledges() == [{"grace", 50}, {"daisy", 40}, {"curly", 30}]
  end
end
