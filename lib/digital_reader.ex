defmodule DigitalReader do
  @moduledoc """
  Documentation for `DigitalReader`.
  """

  alias DigitalReader.DigitalSequence

  defstruct digital_sequences: [],
            digital_sequence: %DigitalSequence{},
            h_pointer: 0,
            v_pointer: 0

  @doc """
  Function that take a file with digital numbers and recognize and validates.
  The results will be written un results.txt on the root of the proyect

  ## Example

      iex> DigitalReader.recognize_numbers("file.txt")
      000000000 OK
      111111111 ERR
      222222222 ERR
      Results written in results.txt
  """
  @spec recognize_numbers(String.t()) :: List.t()
  def recognize_numbers(file_path) do
    File.rm("results.txt")

    file_path
    |> File.stream!([], 1)
    |> get_characters()
    |> verify()
  end

  defp verify(dr = %DigitalReader{}) do
    dr.digital_sequences
    |> Enum.reverse()
    |> Enum.reduce([], fn ds, ds_acc ->
      [DigitalSequence.verify(ds) | ds_acc]
    end)

    IO.puts("Results written in results.txt")
  end

  defp get_characters(file_stream) do
    dr =
      Enum.reduce(file_stream, %DigitalReader{}, fn letter, reader ->
        add_character(reader, letter)
      end)

    %{dr | digital_sequence: nil, digital_sequences: [dr.digital_sequence | dr.digital_sequences]}
  end

  defp add_character(dr = %DigitalReader{}, "\n") do
    update_pointer(dr)
  end

  defp add_character(dr = %DigitalReader{}, letter) do
    digital_sequence =
      dr.digital_sequence
      |> DigitalSequence.add_character(letter)

    %{dr | digital_sequence: digital_sequence}
  end

  defp update_pointer(dr = %DigitalReader{v_pointer: 3}) do
    digital_sequences = dr.digital_sequences

    %{
      dr
      | digital_sequences: [dr.digital_sequence | digital_sequences],
        digital_sequence: %DigitalReader.DigitalSequence{},
        v_pointer: 0
    }
  end

  defp update_pointer(dr = %DigitalReader{}) do
    %{dr | v_pointer: dr.v_pointer + 1}
  end
end
