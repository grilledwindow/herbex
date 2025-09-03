defmodule Herbex do
  def main(_args \\ []) do
    port = Port.open({:spawn, "herbstclient -i"}, [:binary])
    loop()
  end

  defp loop() do
    receive do
      message -> process_message(message)
    end
    loop()
  end

  defp process_message({_port, {:data, data}}) do
    case String.split(data, "\t", trim: true) do
      [hook, winid | _] -> process_hook(hook, winid)
      _ -> nil
    end
  end

  defp process_hook(hook, winid) do
    case hook do
      "focus_changed" -> update_cwd(winid)
      # when "cd" is run in an open terminal, window_title_changed hook is also emitted
      "window_title_changed" -> update_cwd(winid)
      _ -> nil
    end
  end

  defp update_cwd(winid) do
    with {wm_class, 0} <- System.cmd("xprop", ["-id", winid, "WM_CLASS"]),
        [_] <- Regex.run(~r/term/i, wm_class)
    do
      update_cwd()
    end
  end

  defp update_cwd() do
    cwd_file = System.user_home()
      |> Path.join(".cwd")

    with {parent_pid, 0} <- System.cmd(
      "herbstclient", ["get_attr", "clients.focus.pid"])
    do
      parent_pid = String.trim(parent_pid)
      pids = System.cmd("pstree", ["-p", parent_pid])
        |> elem(0)
        |> String.split("\n", trim: true)
        |> List.first()

      [pid] = Regex.scan(~r/(\d+)/, pids, capture: :first)
        |> Enum.at(1)
      {cwd, 0} = System.cmd("readlink", ["/proc/#{pid}/cwd"])
      cwd = String.trim(cwd)

      case File.write(cwd_file, cwd) do
        :ok -> IO.puts("#{cwd} written to #{cwd_file}")
        err -> IO.puts(err)
      end
    else
      _ -> {:error, "Error retrieving PID"}
    end
  end
end
