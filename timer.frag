precision highp float;

varying vec2 f_src_pos;

uniform sampler2D u_texture;
uniform int u_cur_time;

const vec3 pink = vec3(0.8, 0.6, 0.7);
const vec3 white = vec3(1.0, 1.0, 1.0);
const vec3 blue = vec3(0.6, 0.7, 0.8);

vec3 hsv2rgb(vec3 c)
{
    vec3 rgb = clamp(
        abs(mod(c.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0,
        0.0,
        1.0);
    rgb = rgb * rgb * (3.0 - 2.0 * rgb);
    return c.z * mix(vec3(1.0), rgb, c.y);
}

void rainbow()
{
    float time = float(u_cur_time);
    float hue = fract(f_src_pos.x + f_src_pos.y + time * 0.002);

    vec3 new_color = hsv2rgb(vec3(hue, 1.0, 1.0));

    gl_FragColor = vec4(new_color, 1.0);
}

void trans()
{
    float time = float(u_cur_time);
    float hue = fract(f_src_pos.x + f_src_pos.y + time * 0.002);

    vec3 color;
    if (hue < 0.5) {
        color = mix(pink, white, hue * 2.0);
    } else {
        color = mix(white, blue, (hue - 0.5) * 2.0);
    }

    gl_FragColor = vec4(color, 1.0);
}

const float threshold = 0.01;
const vec3 IGT_COLOR = vec3(0.761, 0.686, 0.933);
const vec3 RTA_COLOR = vec3(0.643, 0.839, 0.875);
void main() {
    vec4 color = texture2D(u_texture, f_src_pos);
    bool is_igt = all(lessThan(abs(color.rgb - IGT_COLOR), vec3(threshold)));
    bool is_rta = all(lessThan(abs(color.rgb - RTA_COLOR), vec3(threshold)));
    if (is_igt) {
        rainbow();
    } else if (is_rta) {
        trans();
    } else {
        gl_FragColor = color;
    }
}