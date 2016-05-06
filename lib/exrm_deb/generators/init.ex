defmodule ExrmDeb.Generators.Init do
  alias ReleaseManager.Utils.Logger
  alias ExrmDeb.Generators.TemplateFinder
  import Logger, only: [debug: 1]

  def build(data_dir, config) do
    debug "Building init file"

    init_script =
      TemplateFinder.retrieve(["init_scripts", "init.eex"])
      |> EEx.eval_file([
        description: config.description,
        name: config.name,
        uid: config.owner[:user],
        gid: config.owner[:group]
      ])

    out_dir =
      [data_dir, "etc", "init.d"]
      |> Path.join

    :ok = File.mkdir_p(out_dir)

    file =
      [out_dir, config.sanitized_name]
      |> Path.join

    :ok = File.write(file, init_script)
    :ok = File.chmod(file, 775)
  end

end

