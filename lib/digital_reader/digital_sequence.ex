defmodule DigitalReader.DigitalSequence do
  @moduledoc """
  Documentation for `DigitalReader.DigitalNumber`.
  """

  defstruct digital_numbers: %{},
            status: :OK,
            checksum: 0,
            sequence: [],
            number_pointer: 0,
            character_pointer: 0

  @digital_numbers %{
    " _ | ||_|" => "0",
    "     |  |" => "1",
    " _  _||_ " => "2",
    " _  _| _|" => "3",
    "   |_|  |" => "4",
    " _ |_  _|" => "5",
    " _ |_ |_|" => "6",
    " _   |  |" => "7",
    " _ |_||_|" => "8",
    " _ |_| _|" => "9"
  }

  def add_character(cdn = %__MODULE__{}, letter) do
    new_digital_number =
      cdn.digital_numbers
      |> Map.get(cdn.number_pointer, "")
      |> Kernel.<>(letter)

    new_digital_numbers = Map.put(cdn.digital_numbers, cdn.number_pointer, new_digital_number)

    %{cdn | digital_numbers: new_digital_numbers}
    |> update_pointer
  end

  def verify(ds = %__MODULE__{}) do
    {:ok, file} = File.open("results.txt", [:write, :append])

    ds =
      ds
      |> convert
      |> verify_checksum
      |> print_to_file(file)

    File.close(file)
    ds
  end

  defp convert(ds) do
    Enum.reduce(ds.digital_numbers, ds, fn {_, digital_number}, ds_acc ->
      number = @digital_numbers[digital_number] || "?"
      status = if number == "?" || ds_acc.status == :ILL, do: :ILL, else: :OK
      sequence = [number | ds_acc.sequence]

      %{ds_acc | sequence: sequence, status: status}
    end)
  end

  defp verify_checksum(ds = %{status: :ILL}), do: %{ds | sequence: Enum.reverse(ds.sequence)}

  defp verify_checksum(ds) do
    {_, checksum} =
      Enum.reduce(ds.sequence, {1, 0}, fn number, {position, checksum} ->
        checksum = checksum + position * String.to_integer(number)
        {position + 1, checksum}
      end)

    checksum = rem(checksum, 11)
    status = if checksum == 0, do: :OK, else: :ERR

    %{ds | status: status, checksum: checksum, sequence: Enum.reverse(ds.sequence)}
  end

  defp print_to_file(ds, file) do
    result = "#{ds.sequence} #{ds.status}"
    IO.write(file, "#{result} \n")
    IO.puts(result)
    result
  end

  defp update_pointer(cdn = %__MODULE__{number_pointer: 8, character_pointer: 2}) do
    %{cdn | character_pointer: 0, number_pointer: 0}
  end

  defp update_pointer(cdn = %__MODULE__{character_pointer: 2}) do
    %{cdn | character_pointer: 0, number_pointer: cdn.number_pointer + 1}
  end

  defp update_pointer(cdn = %__MODULE__{character_pointer: cp}) do
    %{cdn | character_pointer: cp + 1}
  end
end
