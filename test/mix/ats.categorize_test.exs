defmodule Mix.Tasks.Ats.CategorizeTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  @result_low """
  +---------------+-------+------+-------------------+---------+------+-------+--------+----------+
  |               | Total | Tech | Marketing / Comm' | Conseil | Créa | Admin | Retail | Business |
  +---------------+-------+------+-------------------+---------+------+-------+--------+----------+
  | Total         | 4910  | 1422 | 769               | 174     | 212  | 404   | 519    | 1410     |
  | Africa        | 8     | 3    | 1                 | 0       | 0    | 1     | 1      | 2        |
  | Asia          | 38    | 9    | 2                 | 0       | 0    | 1     | 7      | 19       |
  | Europe        | 4711  | 1400 | 755               | 174     | 205  | 394   | 422    | 1361     |
  | North America | 145   | 9    | 10                | 0       | 7    | 8     | 87     | 24       |
  | Oceania       | 3     | 0    | 1                 | 0       | 0    | 0     | 2      | 0        |
  | South America | 5     | 1    | 0                 | 0       | 0    | 0     | 0      | 4        |
  +---------------+-------+------+-------------------+---------+------+-------+--------+----------+

  """

  test "ats.categorize without arguments" do
    assert capture_io(fn ->
             Mix.Tasks.Ats.Categorize.run([])
           end) == @result_low
  end

  test "ats.categorize with continent-quality to low" do
    assert capture_io(fn ->
             Mix.Tasks.Ats.Categorize.run(["--continents-quality", "low"])
           end) == @result_low
  end

  test "ats.categorize with invalid continent-quality" do
    assert_raise Mix.Error, fn ->
      Mix.Tasks.Ats.Categorize.run(["--continents-quality", "invalid"])
    end
  end
end
