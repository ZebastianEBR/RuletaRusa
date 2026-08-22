# Juego de ruleta rusa
# Autor: Sebastian Eduardo Ballesteros ruiz
# Licencia: GPL v3
# Version: beta 0.1

defmodule Iniciar do
  def iniciar() do
    jugadores = [%{nombre: "pc1", vivo: true}, %{nombre: "pc2", vivo: true}, %{nombre: "pc3", vivo: true}]


    jugador = Crear_jugador.crear_jugador()
    lista_nueva_jugadores = Agregar_jugador.agregar_jugador(jugadores, jugador)
    IO.puts("#{jugador.nombre}\n")


    Jugar.jugar(lista_nueva_jugadores)


  end
end


#CRUD
defmodule Crear_jugador do
  def crear_jugador() do
    nombre = Ingresar_nombre.ingresar_nombre()
    %{
        nombre: nombre,
        vivo: true
      }
  end
end


defmodule Eliminar_jugador do
  def eliminar_jugador(jugadores, jugador) do
    Enum.reject(jugadores, fn x -> x == jugador end)
  end
end


defmodule Agregar_jugador do
  def agregar_jugador(jugadores, jugador) do
    jugadores ++ [jugador]

  end
end

defmodule Ver_jugadores do
  def ver_jugadores(jugadores) do
    IO.puts("\n--- JUGADORES ---")

    Enum.each(jugadores, fn jugador ->
      estado =
        if jugador.vivo do
          "Vivo"
        else
          "Muerto"
        end

      IO.puts("#{jugador.nombre} | #{estado}")
    end)
  end
end


# juego
defmodule Jugar do
  def jugar(jugadores) do
    revolver = Recargar_revolver.recargar_revolver()

    jugadores_vivos = Emparejar_jugadores.emparejar_jugadores(jugadores)
    Ver_jugadores.ver_jugadores(jugadores_vivos)

    Validar_para_terminar.validar_para_terminar(jugadores_vivos)

    Iniciar_ronda.iniciar_ronda(revolver, jugadores_vivos)


  end
end


defmodule Recargar_revolver do
  def recargar_revolver() do
    IO.puts("frhisss, *Girando el tambor*")
    tambor = [true, false, false, false, false]
    posicion = Enum.random(0..4)

    tambor_dibujo =
      cond do
        posicion == 0 ->
          "             (0)
          ( ) ◉ ( )
           ( ) ( )"

        posicion == 1 ->
          "             ( )
          ( ) ◉ (0)
           ( ) ( )"

        posicion == 2 ->
          "             ( )
          ( ) ◉ ( )
           ( ) (0)"

        posicion == 3 ->
          "             ( )
          ( ) ◉ ( )
           (0) ( )"

        true ->
          "             ( )
          (0) ◉ ( )
           ( ) ( )"
      end
    IO.puts(tambor_dibujo)
    Enum.at(tambor, posicion)
  end
end


defmodule Emparejar_jugadores do
    def emparejar_jugadores(jugadores) do
      IO.puts("SOLO VIVOS")
      Enum.filter(jugadores, fn jugador -> jugador.vivo end)
    end
end


defmodule Iniciar_ronda do
    def iniciar_ronda(revolver, jugadores) do

      turno = Enum.random(0..length(jugadores)-1)
      jugador = Enum.at(jugadores, turno)

      IO.puts("Es el turno de #{jugador.nombre}\n")

      if revolver == false do
          IO.puts("Click, el revolver no ha disparado")
          IO.puts("#{jugador.nombre} sigue vivo\n")

      else
        IO.puts("Pffss, el revolver disparo")
        IO.puts("#{jugador.nombre} a muerto\n")
        IO.puts("\njugador #{jugador.nombre} #{jugador.vivo} eliminado")

        jugador_muerto =
          %{
            nombre: jugador.nombre,
            vivo: false
          }

        Agregar_jugador.agregar_jugador(jugadores, jugador_muerto)
        |> Eliminar_jugador.eliminar_jugador(jugador)
        |> Preguntar_seguir.preguntar_seguir()

      end
      Preguntar_seguir.preguntar_seguir(jugadores)

    end
end


defmodule Validar_para_terminar do
  def validar_para_terminar(jugadores_vivos) do
    case jugadores_vivos do
      [jugador] ->
        Generar_mensaje.generar_mensaje(jugador)
        |> Mostrar_mensaje.mostrar_mensaje()
        Iniciar.iniciar()

      _ -> IO.puts("seguimos")
    end


  end

end


defmodule Generar_mensaje do
  def generar_mensaje(jugador) do
    "Felicidades #{jugador.nombre}, la suerte esta de tu lado, y tienes otra oportunidad para vivir. \n
    Esperamos encarecidamente que hagas algo util y que no juegues cosas tan peligrosas. \n
    Con amor WhoAmI?"
  end
end

defmodule Mostrar_mensaje do
  def mostrar_mensaje(mensaje) do
    IO.puts(mensaje)
  end
end


defmodule Preguntar_seguir do
  def preguntar_seguir(jugadores) do
    otra = IO.gets("Quieres seguir?... s = si y n = no  ")
      |> String.trim()
      if otra == "s" do
        Jugar.jugar(jugadores)
      else
        Iniciar.iniciar()
      end
  end
end

# Utiles
defmodule Ingresar_nombre do
    def ingresar_nombre() do
      IO.gets("Bienvenido, Ingresa tu nombre:  ")
      |> String.trim()
    end
end



Iniciar.iniciar()
