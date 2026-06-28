#pragma once
#include <stdint.h>

typedef enum { PP = 0, PT, MP, MT } shift;

typedef struct 
{
    uint32_t mt: 8;
    uint32_t mp: 8;
    uint32_t pt: 8;
    uint32_t pp: 8;

} uid32;

uint8_t core_extract_byte(uint32_t, uint_fast8_t);
uint32_t core_encode_uid(uint8_t, uint8_t, uint8_t, uint8_t);
uid32 core_decode_uid(uint32_t);

/******************************************************************************************************************************
 * Returns 8-bit value
 * Data : 0x FF FF FF FF
 * index:     3  2  1  0     MSB->LSB
 * *****************************************************************************************************************************/
uint8_t core_extract_byte(uint32_t value, uint_fast8_t byte) {
    return (value >> (byte * 8)) & 0xFF;
}

/******************************************************************************************************************************
 * Returns 32-bit identifier [ AA BB CC DD  ]
 * AA : Module type
 * BB : Module id/position
 * CC : Parameter type
 * DD : Parameter id/position
 * *****************************************************************************************************************************/
uint32_t core_encode_uid(uint8_t mt, uint8_t mp, uint8_t pt, uint8_t pp) {
    return ((mt << 24) | (mp << 16) | (pt << 8) | pp);
}

uid32 core_decode_uid(uint32_t data) {
    uid32 uid = {
        .mt = core_extract_byte(data, MT),
        .mp = core_extract_byte(data, MP),
        .pt = core_extract_byte(data, PT),
        .pp = core_extract_byte(data, PP)
    };

    return uid;
}
