defmodule DigitalReader do
  @moduledoc """
  Documentation for `DigitalReader`.
  """

  defstruct numbers: "", status: :ok

  @digital_numbers %{
    " _ | ||_|" => 0,
    "     |  |" => 1,
    " _  _||_ " => 2,
    " _  _| _|" => 3,
    "   |_|  |" => 4,
    " _ |_  _|" => 5,
    " _ |_ |_|" => 6,
    " _   |  |" => 7,
    " _ |_||_|" => 8,
    " _ |_| _|" => 9
  }


  @doc """
  Function that take a file with digital numbers and recognize them.

  ## Example

      iex> DigitalReader.recognize_numbers("file.txt")
      457508000 OK
      664371495 ERR
      86110??36 ILL

  """
  @spec recognize_numbers(String.t()) :: :ok
  def recognize_numbers(file_path) do
    :ok
  end
end
