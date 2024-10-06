shader_type canvas_item;

uniform sampler2D pattern: repeat_enable;
uniform float speed = 1.0;
uniform float size_scale = 1.0;
uniform vec4 color: source_color;
uniform float rotation = 0.0; // угол наклона в радианах

uniform vec2 size = vec2(2560,1440);

void fragment() {
    vec2 aspect_ratio = vec2(size.x/size.y, 1.0); // соотношение сторон ColorRect
    vec2 centered_uv = (UV * 2.0 - 1.0) * aspect_ratio; // центрируем и корректируем UV по соотношению сторон
    vec2 rotated_uv = vec2(
        centered_uv.x * cos(rotation) - centered_uv.y * sin(rotation),
        centered_uv.x * sin(rotation) + centered_uv.y * cos(rotation)
    ); // поворот UV
    vec2 scaled_uv = size_scale * rotated_uv;
    scaled_uv = scaled_uv * 0.5 + 0.5; // возвращаем UV в диапазон от 0 до 1
    vec2 moving_uv = vec2(scaled_uv.x - (TIME * speed), scaled_uv.y);

    vec4 in_tex = texture(pattern, moving_uv);
    COLOR = in_tex * color; // применяем цвет, если требуется
}
