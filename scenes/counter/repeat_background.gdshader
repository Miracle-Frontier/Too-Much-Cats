shader_type canvas_item; // шейдер для 2d элементов

uniform sampler2D pattern: repeat_enable; // запрашивает изображение и ставит у него настройку на повторение его
uniform float speed = 1.0;
uniform float size_scale = 1.0;
uniform vec4 color: source_color; // запросить цвет и его прибавить

void fragment() { 	// Called for every pixel the material is visible on.
	vec2 centered_uv = UV* 2.0 - 1.0; // 	центрируем UV, теперь он от -1 до 1, а не от 0 до 1
	vec2 scaled_uv = size_scale * centered_uv; // каждый пиксель будет увеличен
	scaled_uv = scaled_uv * 0.5 + 0.5; // возвращаем их в диапозон от 0 До 1
	vec2 moving_uv = vec2(scaled_uv.x - (TIME*speed), scaled_uv.y);
	vec4 in_tex = texture(pattern, moving_uv);
	COLOR = in_tex; // можно добавить * color чтобы умножался на source_color
}