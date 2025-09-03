defmodule Herbex do
  def main(_args \\ []) do
    port = Port.open({:spawn, "herbstclient -i"}, [:binary])
    loop()
  end

  defp loop() do
    receive do
      message -> process_hook(message)
    end
    loop()
  end

  defp process_hook({_port, {:data, data}}) do
    [hook | _] = String.split(data, "\t")

    case hook do
      "focus_changed" -> update_cwd()
      # when "cd" is run in an open terminal, window_title_changed hook is also emitted
      "window_title_changed" -> update_cwd()
      _ -> nil
    end
  end

  defp update_cwd() do
    file = System.user_home()
      |> Path.join(".cwd")
    case System.cmd("herbstclient", ["get_attr", "clients.focus.pid"])
    do
      {parent_pid, 0} ->
        parent_pid = String.trim(parent_pid)
        pids = System.cmd("pstree", ["-p", parent_pid])
          |> elem(0)
          |> String.split("\n", trim: true)
          |> List.first()

        [pid] = Regex.scan(~r/(\d+)/, pids, capture: :first)
          |> Enum.at(1)
        {cwd, 0} = System.cmd("readlink", ["/proc/#{pid}/cwd"])
        cwd = String.trim(cwd)

        case File.write(file, cwd) do
          :ok -> IO.puts("#{cwd} written to #{file}")
          err -> IO.puts(err)
        end

      _ -> {:error, "Error retrieving PID"}
    end
  end
end
