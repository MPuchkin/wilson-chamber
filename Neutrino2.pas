uses GraphWPF;

const startSpeed = 50.0;

/// <summary>
/// Моделирование движения частицы, рекурсивное, возможно с распадом
/// </summary>
/// <param name="x">Текущая координата X</param>
/// <param name="y">Текущая координата Y</param>
/// <param name="alpha">Направление движения - угол наклона к оси Ox</param>
/// <param name="speed">Скорость движения</param>
/// <param name="force">Сила, представляющая действие магнитного поля на частицу</param>
procedure RunParticle(x, y, alpha, speed, force : real);
begin
  //  Если скорость слишком мала, или вышли за границы окна - прекращаем рисование
  if (speed < 1) or (x > Window.Width) then exit;
  //  Распад частицы - с вероятностью 3%, слишком медленные (электроны) не распадаются
  //  и если скорость высока, то распада нет (чтобы не распадались сразу на старте)
  if (speed > startSpeed/5) and (speed < startSpeed*0.82) and (Random(1.0) < 0.03) then
  begin
    // Три частицы - две с почти такой же скоростью, и одна мелкая/медленная (электрон)
    RunParticle(x, y, alpha + Random(-0.1,-0.4), speed*0.94, force);
    RunParticle(x, y, alpha + Random(0.1,0.2), speed*0.95, force);
    RunParticle(x, y, alpha, speed*0.15, force*Random(10,20));
  end
  else
  begin
    //  Эта ветка - просто движение частицы, без распада
    alpha += force;  //  угол движения меняется под действием силы
    var (x2, y2) := (x+cos(alpha)*speed, y-sin(alpha)*speed);  //  уравнение движения
    Pen.Width := 1+speed/20;   //  толщина линии зависит от скорости - быстрые ярче
    Pen.Color := Colors.White;
    if Random > 0.1 then       //  сегмент пути рисуется с вероятностью в 90%
      Line(x, y, x2, y2);
    RunParticle(x2, y2, alpha, speed*0.993, force);  //  рекурсивно продолжаем движение
  end;
end;

begin
  //  Настройка окна
  Window.Maximize;
  Window.Clear(Colors.Black);
  Pen.Color := Colors.White;
  //  Запуск 20 частиц
  loop 20 do
    RunParticle(0, Window.Height/2, DegToRad(Random(-10, 10)), Random(startSpeed,0.85*startSpeed), Random(-0.01,0.01));
  //  Сохраняем в файл
  Window.Save('Wilson.jpg');
end.