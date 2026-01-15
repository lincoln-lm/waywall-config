#version 300 es
precision highp float;

in vec2 f_src_pos;

uniform sampler2D u_texture;
uniform int u_cur_time;

out vec4 fragColor;

const float threshold = 0.01;
const vec3 TEXT_COLOR = vec3(0.866, 0.866, 0.866);

const int LINE_END_COUNTER_MAX = 30;
const int SPACE_WIDTH = 9;

// beware
vec4 getPixel(ivec4 anchor, vec2 f_src_pos, sampler2D u_texture) {
    vec2 texel_size = 1.0 / vec2(textureSize(u_texture, 0));
    ivec2 current_texel = ivec2(f_src_pos * vec2(textureSize(u_texture, 0))) - ivec2(anchor.x, anchor.y);

    int line_end_counter = LINE_END_COUNTER_MAX;
    int line_end = 0;
    int x_end = 0;
    int y_end = 0;
    for (int x = 0; x < anchor.z; x++) {
        bool has_text = false;
        for (int y = 0; y < anchor.w; y += 3) {
            vec2 offset = vec2(float(x + anchor.x) * texel_size.x, float(y + anchor.y) * texel_size.y);
            vec4 color = texture(u_texture, offset);
            bool is_text = all(lessThan(abs(color.rgb - TEXT_COLOR), vec3(threshold)));

            if (is_text) {
                has_text = true;
                break;
            }
        }
        if (line_end_counter == LINE_END_COUNTER_MAX - SPACE_WIDTH) {
            if (x_end == 0) {
                x_end = x;
            } else if (y_end == 0) {
                y_end = x;
            }
        }
        if (has_text) {
            line_end_counter = LINE_END_COUNTER_MAX;
        } else {
            line_end_counter--;
        }
        if (line_end_counter <= 0) {
            line_end = x - line_end_counter;
            break;
        }
    }
    if (line_end == 0 || x_end == 0 || y_end == 0) {
        return vec4(0.0, 0.0, 0.0, 0.0);
    }
    current_texel.x -= (anchor.z - line_end) / 2;
    if (current_texel.x < 0) {
        return vec4(0.0, 0.0, 0.0, 0.0);
    }
    vec2 offset = vec2(float(current_texel.x + anchor.x) * texel_size.x, float(current_texel.y + anchor.y) * texel_size.y);
    bool is_text = all(lessThan(abs(texture(u_texture, offset).rgb - TEXT_COLOR), vec3(threshold)));
    if (is_text) {
        if (current_texel.x < x_end) {
            return vec4(1.0, 0.0, 0.0, 1.0);
        } else if (current_texel.x < y_end) {
            return vec4(0.0, 1.0, 0.0, 1.0);
        } else {
            return vec4(0.5, 0.5, 1.0, 1.0);
        }
    }
    bool is_shadow = all(lessThan(abs(texture(u_texture, offset - 2.0*texel_size).rgb - TEXT_COLOR), vec3(threshold)));
    if (is_shadow) {
        return vec4(0.09, 0.04, 0.027, 1.0);
    }
    return vec4(0.0, 0.0, 0.0, 0.0);
}

void main() {
    ivec4 anchor = ivec4(ANCHOR);
    fragColor = getPixel(anchor, f_src_pos, u_texture);
}