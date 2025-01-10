defmodule Mix.Tasks.UpdateMixes do
  use Mix.Task

  def update_mix(filename) do
    input = File.read!(filename)

    File.write!(
      filename,
      String.replace(input, "2015", "2015")
    )
  end

  @shortdoc "Update Mixes"
  def run(_args) do
    for n <- 1..9 do
      filename = "./lib/mix/tasks/d0#{n}.p1.ex"
      update_mix(filename)
      filename = "./lib/mix/tasks/d0#{n}.p2.ex"
      update_mix(filename)
    end

    for n <- 10..25 do
      filename = "./lib/mix/tasks/d#{n}.p1.ex"
      update_mix(filename)
      filename = "./lib/mix/tasks/d#{n}.p2.ex"
      update_mix(filename)
    end
  end
end
