global table = comptime { make_lookup_table() };
pub fn regex_match<let N: u32>(input: [u8; N]) -> Vec<BoundedVec<Field, N>> {
    // regex: (\r\n|^)to:[^\r\n]+\r\n
    let mut substrings: Vec<BoundedVec<Field, N>> = Vec::new();

    // "Previous" state
    let mut s: Field = 0;
    s = table[255];
    // "Next"/upcoming state
    let mut s_next: Field = 0;

    let mut consecutive_substr = 0;
    let mut current_substring = BoundedVec::new();

    for i in 0..input.len() {
        let temp = input[i] as Field;
        let mut reset = false;
        s_next = table[s * 256 + temp];
        if s_next == 0 {
          // Check if there is any transition that could be done from a "restart"
          s_next = table[temp];
          // whether the next state changes or not, we mark this as a reset.
          reset = true;
          s = 0;
        }

        // If a substring was in the making, but the state was reset
        // we disregard previous progress because apparently it is invalid
        if (reset & (consecutive_substr == 1)) {
            current_substring = BoundedVec::new();
            consecutive_substr = 0;
        }
        // Fill up substrings
        if ((s == 5) & (s_next == 6) | (s == 5) & (s_next == 7) | (s == 5) & (s_next == 8) | (s == 5) & (s_next == 9) | (s == 5) & (s_next == 10) | (s == 5) & (s_next == 11) | (s == 5) & (s_next == 12) | (s == 5) & (s_next == 13) | (s == 6) & (s_next == 6) | (s == 6) & (s_next == 7) | (s == 6) & (s_next == 8) | (s == 6) & (s_next == 9) | (s == 6) & (s_next == 10) | (s == 6) & (s_next == 11) | (s == 6) & (s_next == 12) | (s == 6) & (s_next == 13) | (s == 7) & (s_next == 6) | (s == 8) & (s_next == 7) | (s == 9) & (s_next == 7) | (s == 10) & (s_next == 7) | (s == 11) & (s_next == 9) | (s == 12) & (s_next == 9) | (s == 13) & (s_next == 9)) {
            if (consecutive_substr == 0) {
              current_substring.push(temp);
              consecutive_substr = 1;
            } else if (consecutive_substr == 1) {
              current_substring.push(temp);
            }   
        } else if ((consecutive_substr == 1) & (s_next == 0)) {
            current_substring = BoundedVec::new();
            consecutive_substr = 0;
        } else if (consecutive_substr == 1) {
            // The substring is done so "save" it
            substrings.push(current_substring);
            // reset the substring holder for next use
            current_substring = BoundedVec::new();
            consecutive_substr = 0;
        }
        s = s_next;
    }
    assert((s == 15) | (s == 16), f"no match: {s}");
    // Add pending substring that hasn't been added
    if consecutive_substr == 1 {
        substrings.push(current_substring);
    }
    substrings
}
        
comptime fn make_lookup_table() -> [Field; 4352] {
    let mut table = [0; 4352];
    table[15 * 256 + 0] = 16;
    table[16 * 256 + 0] = 16;
    table[15 * 256 + 1] = 16;
    table[16 * 256 + 1] = 16;
    table[15 * 256 + 2] = 16;
    table[16 * 256 + 2] = 16;
    table[15 * 256 + 3] = 16;
    table[16 * 256 + 3] = 16;
    table[15 * 256 + 4] = 16;
    table[16 * 256 + 4] = 16;
    table[15 * 256 + 5] = 16;
    table[16 * 256 + 5] = 16;
    table[15 * 256 + 6] = 16;
    table[16 * 256 + 6] = 16;
    table[15 * 256 + 7] = 16;
    table[16 * 256 + 7] = 16;
    table[15 * 256 + 8] = 16;
    table[16 * 256 + 8] = 16;
    table[15 * 256 + 9] = 16;
    table[16 * 256 + 9] = 16;
    table[15 * 256 + 10] = 16;
    table[16 * 256 + 10] = 16;
    table[15 * 256 + 11] = 16;
    table[16 * 256 + 11] = 16;
    table[15 * 256 + 12] = 16;
    table[16 * 256 + 12] = 16;
    table[15 * 256 + 13] = 16;
    table[16 * 256 + 13] = 16;
    table[15 * 256 + 14] = 16;
    table[16 * 256 + 14] = 16;
    table[15 * 256 + 15] = 16;
    table[16 * 256 + 15] = 16;
    table[15 * 256 + 16] = 16;
    table[16 * 256 + 16] = 16;
    table[15 * 256 + 17] = 16;
    table[16 * 256 + 17] = 16;
    table[15 * 256 + 18] = 16;
    table[16 * 256 + 18] = 16;
    table[15 * 256 + 19] = 16;
    table[16 * 256 + 19] = 16;
    table[15 * 256 + 20] = 16;
    table[16 * 256 + 20] = 16;
    table[15 * 256 + 21] = 16;
    table[16 * 256 + 21] = 16;
    table[15 * 256 + 22] = 16;
    table[16 * 256 + 22] = 16;
    table[15 * 256 + 23] = 16;
    table[16 * 256 + 23] = 16;
    table[15 * 256 + 24] = 16;
    table[16 * 256 + 24] = 16;
    table[15 * 256 + 25] = 16;
    table[16 * 256 + 25] = 16;
    table[15 * 256 + 26] = 16;
    table[16 * 256 + 26] = 16;
    table[15 * 256 + 27] = 16;
    table[16 * 256 + 27] = 16;
    table[15 * 256 + 28] = 16;
    table[16 * 256 + 28] = 16;
    table[15 * 256 + 29] = 16;
    table[16 * 256 + 29] = 16;
    table[15 * 256 + 30] = 16;
    table[16 * 256 + 30] = 16;
    table[15 * 256 + 31] = 16;
    table[16 * 256 + 31] = 16;
    table[15 * 256 + 32] = 16;
    table[16 * 256 + 32] = 16;
    table[15 * 256 + 33] = 16;
    table[16 * 256 + 33] = 16;
    table[15 * 256 + 34] = 16;
    table[16 * 256 + 34] = 16;
    table[15 * 256 + 35] = 16;
    table[16 * 256 + 35] = 16;
    table[15 * 256 + 36] = 16;
    table[16 * 256 + 36] = 16;
    table[15 * 256 + 37] = 16;
    table[16 * 256 + 37] = 16;
    table[15 * 256 + 38] = 16;
    table[16 * 256 + 38] = 16;
    table[15 * 256 + 39] = 16;
    table[16 * 256 + 39] = 16;
    table[15 * 256 + 40] = 16;
    table[16 * 256 + 40] = 16;
    table[15 * 256 + 41] = 16;
    table[16 * 256 + 41] = 16;
    table[15 * 256 + 42] = 16;
    table[16 * 256 + 42] = 16;
    table[15 * 256 + 43] = 16;
    table[16 * 256 + 43] = 16;
    table[15 * 256 + 44] = 16;
    table[16 * 256 + 44] = 16;
    table[15 * 256 + 45] = 16;
    table[16 * 256 + 45] = 16;
    table[15 * 256 + 46] = 16;
    table[16 * 256 + 46] = 16;
    table[15 * 256 + 47] = 16;
    table[16 * 256 + 47] = 16;
    table[15 * 256 + 48] = 16;
    table[16 * 256 + 48] = 16;
    table[15 * 256 + 49] = 16;
    table[16 * 256 + 49] = 16;
    table[15 * 256 + 50] = 16;
    table[16 * 256 + 50] = 16;
    table[15 * 256 + 51] = 16;
    table[16 * 256 + 51] = 16;
    table[15 * 256 + 52] = 16;
    table[16 * 256 + 52] = 16;
    table[15 * 256 + 53] = 16;
    table[16 * 256 + 53] = 16;
    table[15 * 256 + 54] = 16;
    table[16 * 256 + 54] = 16;
    table[15 * 256 + 55] = 16;
    table[16 * 256 + 55] = 16;
    table[15 * 256 + 56] = 16;
    table[16 * 256 + 56] = 16;
    table[15 * 256 + 57] = 16;
    table[16 * 256 + 57] = 16;
    table[15 * 256 + 58] = 16;
    table[16 * 256 + 58] = 16;
    table[15 * 256 + 59] = 16;
    table[16 * 256 + 59] = 16;
    table[15 * 256 + 60] = 16;
    table[16 * 256 + 60] = 16;
    table[15 * 256 + 61] = 16;
    table[16 * 256 + 61] = 16;
    table[15 * 256 + 62] = 16;
    table[16 * 256 + 62] = 16;
    table[15 * 256 + 63] = 16;
    table[16 * 256 + 63] = 16;
    table[15 * 256 + 64] = 16;
    table[16 * 256 + 64] = 16;
    table[15 * 256 + 65] = 16;
    table[16 * 256 + 65] = 16;
    table[15 * 256 + 66] = 16;
    table[16 * 256 + 66] = 16;
    table[15 * 256 + 67] = 16;
    table[16 * 256 + 67] = 16;
    table[15 * 256 + 68] = 16;
    table[16 * 256 + 68] = 16;
    table[15 * 256 + 69] = 16;
    table[16 * 256 + 69] = 16;
    table[15 * 256 + 70] = 16;
    table[16 * 256 + 70] = 16;
    table[15 * 256 + 71] = 16;
    table[16 * 256 + 71] = 16;
    table[15 * 256 + 72] = 16;
    table[16 * 256 + 72] = 16;
    table[15 * 256 + 73] = 16;
    table[16 * 256 + 73] = 16;
    table[15 * 256 + 74] = 16;
    table[16 * 256 + 74] = 16;
    table[15 * 256 + 75] = 16;
    table[16 * 256 + 75] = 16;
    table[15 * 256 + 76] = 16;
    table[16 * 256 + 76] = 16;
    table[15 * 256 + 77] = 16;
    table[16 * 256 + 77] = 16;
    table[15 * 256 + 78] = 16;
    table[16 * 256 + 78] = 16;
    table[15 * 256 + 79] = 16;
    table[16 * 256 + 79] = 16;
    table[15 * 256 + 80] = 16;
    table[16 * 256 + 80] = 16;
    table[15 * 256 + 81] = 16;
    table[16 * 256 + 81] = 16;
    table[15 * 256 + 82] = 16;
    table[16 * 256 + 82] = 16;
    table[15 * 256 + 83] = 16;
    table[16 * 256 + 83] = 16;
    table[15 * 256 + 84] = 16;
    table[16 * 256 + 84] = 16;
    table[15 * 256 + 85] = 16;
    table[16 * 256 + 85] = 16;
    table[15 * 256 + 86] = 16;
    table[16 * 256 + 86] = 16;
    table[15 * 256 + 87] = 16;
    table[16 * 256 + 87] = 16;
    table[15 * 256 + 88] = 16;
    table[16 * 256 + 88] = 16;
    table[15 * 256 + 89] = 16;
    table[16 * 256 + 89] = 16;
    table[15 * 256 + 90] = 16;
    table[16 * 256 + 90] = 16;
    table[15 * 256 + 91] = 16;
    table[16 * 256 + 91] = 16;
    table[15 * 256 + 92] = 16;
    table[16 * 256 + 92] = 16;
    table[15 * 256 + 93] = 16;
    table[16 * 256 + 93] = 16;
    table[15 * 256 + 94] = 16;
    table[16 * 256 + 94] = 16;
    table[15 * 256 + 95] = 16;
    table[16 * 256 + 95] = 16;
    table[15 * 256 + 96] = 16;
    table[16 * 256 + 96] = 16;
    table[15 * 256 + 97] = 16;
    table[16 * 256 + 97] = 16;
    table[15 * 256 + 98] = 16;
    table[16 * 256 + 98] = 16;
    table[15 * 256 + 99] = 16;
    table[16 * 256 + 99] = 16;
    table[15 * 256 + 100] = 16;
    table[16 * 256 + 100] = 16;
    table[15 * 256 + 101] = 16;
    table[16 * 256 + 101] = 16;
    table[15 * 256 + 102] = 16;
    table[16 * 256 + 102] = 16;
    table[15 * 256 + 103] = 16;
    table[16 * 256 + 103] = 16;
    table[15 * 256 + 104] = 16;
    table[16 * 256 + 104] = 16;
    table[15 * 256 + 105] = 16;
    table[16 * 256 + 105] = 16;
    table[15 * 256 + 106] = 16;
    table[16 * 256 + 106] = 16;
    table[15 * 256 + 107] = 16;
    table[16 * 256 + 107] = 16;
    table[15 * 256 + 108] = 16;
    table[16 * 256 + 108] = 16;
    table[15 * 256 + 109] = 16;
    table[16 * 256 + 109] = 16;
    table[15 * 256 + 110] = 16;
    table[16 * 256 + 110] = 16;
    table[15 * 256 + 111] = 16;
    table[16 * 256 + 111] = 16;
    table[15 * 256 + 112] = 16;
    table[16 * 256 + 112] = 16;
    table[15 * 256 + 113] = 16;
    table[16 * 256 + 113] = 16;
    table[15 * 256 + 114] = 16;
    table[16 * 256 + 114] = 16;
    table[15 * 256 + 115] = 16;
    table[16 * 256 + 115] = 16;
    table[15 * 256 + 116] = 16;
    table[16 * 256 + 116] = 16;
    table[15 * 256 + 117] = 16;
    table[16 * 256 + 117] = 16;
    table[15 * 256 + 118] = 16;
    table[16 * 256 + 118] = 16;
    table[15 * 256 + 119] = 16;
    table[16 * 256 + 119] = 16;
    table[15 * 256 + 120] = 16;
    table[16 * 256 + 120] = 16;
    table[15 * 256 + 121] = 16;
    table[16 * 256 + 121] = 16;
    table[15 * 256 + 122] = 16;
    table[16 * 256 + 122] = 16;
    table[15 * 256 + 123] = 16;
    table[16 * 256 + 123] = 16;
    table[15 * 256 + 124] = 16;
    table[16 * 256 + 124] = 16;
    table[15 * 256 + 125] = 16;
    table[16 * 256 + 125] = 16;
    table[15 * 256 + 126] = 16;
    table[16 * 256 + 126] = 16;
    table[15 * 256 + 127] = 16;
    table[16 * 256 + 127] = 16;
    table[15 * 256 + 128] = 16;
    table[16 * 256 + 128] = 16;
    table[15 * 256 + 129] = 16;
    table[16 * 256 + 129] = 16;
    table[15 * 256 + 130] = 16;
    table[16 * 256 + 130] = 16;
    table[15 * 256 + 131] = 16;
    table[16 * 256 + 131] = 16;
    table[15 * 256 + 132] = 16;
    table[16 * 256 + 132] = 16;
    table[15 * 256 + 133] = 16;
    table[16 * 256 + 133] = 16;
    table[15 * 256 + 134] = 16;
    table[16 * 256 + 134] = 16;
    table[15 * 256 + 135] = 16;
    table[16 * 256 + 135] = 16;
    table[15 * 256 + 136] = 16;
    table[16 * 256 + 136] = 16;
    table[15 * 256 + 137] = 16;
    table[16 * 256 + 137] = 16;
    table[15 * 256 + 138] = 16;
    table[16 * 256 + 138] = 16;
    table[15 * 256 + 139] = 16;
    table[16 * 256 + 139] = 16;
    table[15 * 256 + 140] = 16;
    table[16 * 256 + 140] = 16;
    table[15 * 256 + 141] = 16;
    table[16 * 256 + 141] = 16;
    table[15 * 256 + 142] = 16;
    table[16 * 256 + 142] = 16;
    table[15 * 256 + 143] = 16;
    table[16 * 256 + 143] = 16;
    table[15 * 256 + 144] = 16;
    table[16 * 256 + 144] = 16;
    table[15 * 256 + 145] = 16;
    table[16 * 256 + 145] = 16;
    table[15 * 256 + 146] = 16;
    table[16 * 256 + 146] = 16;
    table[15 * 256 + 147] = 16;
    table[16 * 256 + 147] = 16;
    table[15 * 256 + 148] = 16;
    table[16 * 256 + 148] = 16;
    table[15 * 256 + 149] = 16;
    table[16 * 256 + 149] = 16;
    table[15 * 256 + 150] = 16;
    table[16 * 256 + 150] = 16;
    table[15 * 256 + 151] = 16;
    table[16 * 256 + 151] = 16;
    table[15 * 256 + 152] = 16;
    table[16 * 256 + 152] = 16;
    table[15 * 256 + 153] = 16;
    table[16 * 256 + 153] = 16;
    table[15 * 256 + 154] = 16;
    table[16 * 256 + 154] = 16;
    table[15 * 256 + 155] = 16;
    table[16 * 256 + 155] = 16;
    table[15 * 256 + 156] = 16;
    table[16 * 256 + 156] = 16;
    table[15 * 256 + 157] = 16;
    table[16 * 256 + 157] = 16;
    table[15 * 256 + 158] = 16;
    table[16 * 256 + 158] = 16;
    table[15 * 256 + 159] = 16;
    table[16 * 256 + 159] = 16;
    table[15 * 256 + 160] = 16;
    table[16 * 256 + 160] = 16;
    table[15 * 256 + 161] = 16;
    table[16 * 256 + 161] = 16;
    table[15 * 256 + 162] = 16;
    table[16 * 256 + 162] = 16;
    table[15 * 256 + 163] = 16;
    table[16 * 256 + 163] = 16;
    table[15 * 256 + 164] = 16;
    table[16 * 256 + 164] = 16;
    table[15 * 256 + 165] = 16;
    table[16 * 256 + 165] = 16;
    table[15 * 256 + 166] = 16;
    table[16 * 256 + 166] = 16;
    table[15 * 256 + 167] = 16;
    table[16 * 256 + 167] = 16;
    table[15 * 256 + 168] = 16;
    table[16 * 256 + 168] = 16;
    table[15 * 256 + 169] = 16;
    table[16 * 256 + 169] = 16;
    table[15 * 256 + 170] = 16;
    table[16 * 256 + 170] = 16;
    table[15 * 256 + 171] = 16;
    table[16 * 256 + 171] = 16;
    table[15 * 256 + 172] = 16;
    table[16 * 256 + 172] = 16;
    table[15 * 256 + 173] = 16;
    table[16 * 256 + 173] = 16;
    table[15 * 256 + 174] = 16;
    table[16 * 256 + 174] = 16;
    table[15 * 256 + 175] = 16;
    table[16 * 256 + 175] = 16;
    table[15 * 256 + 176] = 16;
    table[16 * 256 + 176] = 16;
    table[15 * 256 + 177] = 16;
    table[16 * 256 + 177] = 16;
    table[15 * 256 + 178] = 16;
    table[16 * 256 + 178] = 16;
    table[15 * 256 + 179] = 16;
    table[16 * 256 + 179] = 16;
    table[15 * 256 + 180] = 16;
    table[16 * 256 + 180] = 16;
    table[15 * 256 + 181] = 16;
    table[16 * 256 + 181] = 16;
    table[15 * 256 + 182] = 16;
    table[16 * 256 + 182] = 16;
    table[15 * 256 + 183] = 16;
    table[16 * 256 + 183] = 16;
    table[15 * 256 + 184] = 16;
    table[16 * 256 + 184] = 16;
    table[15 * 256 + 185] = 16;
    table[16 * 256 + 185] = 16;
    table[15 * 256 + 186] = 16;
    table[16 * 256 + 186] = 16;
    table[15 * 256 + 187] = 16;
    table[16 * 256 + 187] = 16;
    table[15 * 256 + 188] = 16;
    table[16 * 256 + 188] = 16;
    table[15 * 256 + 189] = 16;
    table[16 * 256 + 189] = 16;
    table[15 * 256 + 190] = 16;
    table[16 * 256 + 190] = 16;
    table[15 * 256 + 191] = 16;
    table[16 * 256 + 191] = 16;
    table[15 * 256 + 192] = 16;
    table[16 * 256 + 192] = 16;
    table[15 * 256 + 193] = 16;
    table[16 * 256 + 193] = 16;
    table[15 * 256 + 194] = 16;
    table[16 * 256 + 194] = 16;
    table[15 * 256 + 195] = 16;
    table[16 * 256 + 195] = 16;
    table[15 * 256 + 196] = 16;
    table[16 * 256 + 196] = 16;
    table[15 * 256 + 197] = 16;
    table[16 * 256 + 197] = 16;
    table[15 * 256 + 198] = 16;
    table[16 * 256 + 198] = 16;
    table[15 * 256 + 199] = 16;
    table[16 * 256 + 199] = 16;
    table[15 * 256 + 200] = 16;
    table[16 * 256 + 200] = 16;
    table[15 * 256 + 201] = 16;
    table[16 * 256 + 201] = 16;
    table[15 * 256 + 202] = 16;
    table[16 * 256 + 202] = 16;
    table[15 * 256 + 203] = 16;
    table[16 * 256 + 203] = 16;
    table[15 * 256 + 204] = 16;
    table[16 * 256 + 204] = 16;
    table[15 * 256 + 205] = 16;
    table[16 * 256 + 205] = 16;
    table[15 * 256 + 206] = 16;
    table[16 * 256 + 206] = 16;
    table[15 * 256 + 207] = 16;
    table[16 * 256 + 207] = 16;
    table[15 * 256 + 208] = 16;
    table[16 * 256 + 208] = 16;
    table[15 * 256 + 209] = 16;
    table[16 * 256 + 209] = 16;
    table[15 * 256 + 210] = 16;
    table[16 * 256 + 210] = 16;
    table[15 * 256 + 211] = 16;
    table[16 * 256 + 211] = 16;
    table[15 * 256 + 212] = 16;
    table[16 * 256 + 212] = 16;
    table[15 * 256 + 213] = 16;
    table[16 * 256 + 213] = 16;
    table[15 * 256 + 214] = 16;
    table[16 * 256 + 214] = 16;
    table[15 * 256 + 215] = 16;
    table[16 * 256 + 215] = 16;
    table[15 * 256 + 216] = 16;
    table[16 * 256 + 216] = 16;
    table[15 * 256 + 217] = 16;
    table[16 * 256 + 217] = 16;
    table[15 * 256 + 218] = 16;
    table[16 * 256 + 218] = 16;
    table[15 * 256 + 219] = 16;
    table[16 * 256 + 219] = 16;
    table[15 * 256 + 220] = 16;
    table[16 * 256 + 220] = 16;
    table[15 * 256 + 221] = 16;
    table[16 * 256 + 221] = 16;
    table[15 * 256 + 222] = 16;
    table[16 * 256 + 222] = 16;
    table[15 * 256 + 223] = 16;
    table[16 * 256 + 223] = 16;
    table[15 * 256 + 224] = 16;
    table[16 * 256 + 224] = 16;
    table[15 * 256 + 225] = 16;
    table[16 * 256 + 225] = 16;
    table[15 * 256 + 226] = 16;
    table[16 * 256 + 226] = 16;
    table[15 * 256 + 227] = 16;
    table[16 * 256 + 227] = 16;
    table[15 * 256 + 228] = 16;
    table[16 * 256 + 228] = 16;
    table[15 * 256 + 229] = 16;
    table[16 * 256 + 229] = 16;
    table[15 * 256 + 230] = 16;
    table[16 * 256 + 230] = 16;
    table[15 * 256 + 231] = 16;
    table[16 * 256 + 231] = 16;
    table[15 * 256 + 232] = 16;
    table[16 * 256 + 232] = 16;
    table[15 * 256 + 233] = 16;
    table[16 * 256 + 233] = 16;
    table[15 * 256 + 234] = 16;
    table[16 * 256 + 234] = 16;
    table[15 * 256 + 235] = 16;
    table[16 * 256 + 235] = 16;
    table[15 * 256 + 236] = 16;
    table[16 * 256 + 236] = 16;
    table[15 * 256 + 237] = 16;
    table[16 * 256 + 237] = 16;
    table[15 * 256 + 238] = 16;
    table[16 * 256 + 238] = 16;
    table[15 * 256 + 239] = 16;
    table[16 * 256 + 239] = 16;
    table[15 * 256 + 240] = 16;
    table[16 * 256 + 240] = 16;
    table[15 * 256 + 241] = 16;
    table[16 * 256 + 241] = 16;
    table[15 * 256 + 242] = 16;
    table[16 * 256 + 242] = 16;
    table[15 * 256 + 243] = 16;
    table[16 * 256 + 243] = 16;
    table[15 * 256 + 244] = 16;
    table[16 * 256 + 244] = 16;
    table[15 * 256 + 245] = 16;
    table[16 * 256 + 245] = 16;
    table[15 * 256 + 246] = 16;
    table[16 * 256 + 246] = 16;
    table[15 * 256 + 247] = 16;
    table[16 * 256 + 247] = 16;
    table[15 * 256 + 248] = 16;
    table[16 * 256 + 248] = 16;
    table[15 * 256 + 249] = 16;
    table[16 * 256 + 249] = 16;
    table[15 * 256 + 250] = 16;
    table[16 * 256 + 250] = 16;
    table[15 * 256 + 251] = 16;
    table[16 * 256 + 251] = 16;
    table[15 * 256 + 252] = 16;
    table[16 * 256 + 252] = 16;
    table[15 * 256 + 253] = 16;
    table[16 * 256 + 253] = 16;
    table[15 * 256 + 254] = 16;
    table[16 * 256 + 254] = 16;
    table[0 * 256 + 13] = 1;
    table[0 * 256 + 255] = 2;
    table[1 * 256 + 10] = 2;
    table[2 * 256 + 116] = 3;
    table[3 * 256 + 111] = 4;
    table[4 * 256 + 58] = 5;
    table[5 * 256 + 0] = 6;
    table[5 * 256 + 1] = 6;
    table[5 * 256 + 2] = 6;
    table[5 * 256 + 3] = 6;
    table[5 * 256 + 4] = 6;
    table[5 * 256 + 5] = 6;
    table[5 * 256 + 6] = 6;
    table[5 * 256 + 7] = 6;
    table[5 * 256 + 8] = 6;
    table[5 * 256 + 9] = 6;
    table[5 * 256 + 11] = 6;
    table[5 * 256 + 12] = 6;
    table[5 * 256 + 14] = 6;
    table[5 * 256 + 15] = 6;
    table[5 * 256 + 16] = 6;
    table[5 * 256 + 17] = 6;
    table[5 * 256 + 18] = 6;
    table[5 * 256 + 19] = 6;
    table[5 * 256 + 20] = 6;
    table[5 * 256 + 21] = 6;
    table[5 * 256 + 22] = 6;
    table[5 * 256 + 23] = 6;
    table[5 * 256 + 24] = 6;
    table[5 * 256 + 25] = 6;
    table[5 * 256 + 26] = 6;
    table[5 * 256 + 27] = 6;
    table[5 * 256 + 28] = 6;
    table[5 * 256 + 29] = 6;
    table[5 * 256 + 30] = 6;
    table[5 * 256 + 31] = 6;
    table[5 * 256 + 32] = 6;
    table[5 * 256 + 33] = 6;
    table[5 * 256 + 34] = 6;
    table[5 * 256 + 35] = 6;
    table[5 * 256 + 36] = 6;
    table[5 * 256 + 37] = 6;
    table[5 * 256 + 38] = 6;
    table[5 * 256 + 39] = 6;
    table[5 * 256 + 40] = 6;
    table[5 * 256 + 41] = 6;
    table[5 * 256 + 42] = 6;
    table[5 * 256 + 43] = 6;
    table[5 * 256 + 44] = 6;
    table[5 * 256 + 45] = 6;
    table[5 * 256 + 46] = 6;
    table[5 * 256 + 47] = 6;
    table[5 * 256 + 48] = 6;
    table[5 * 256 + 49] = 6;
    table[5 * 256 + 50] = 6;
    table[5 * 256 + 51] = 6;
    table[5 * 256 + 52] = 6;
    table[5 * 256 + 53] = 6;
    table[5 * 256 + 54] = 6;
    table[5 * 256 + 55] = 6;
    table[5 * 256 + 56] = 6;
    table[5 * 256 + 57] = 6;
    table[5 * 256 + 58] = 6;
    table[5 * 256 + 59] = 6;
    table[5 * 256 + 60] = 6;
    table[5 * 256 + 61] = 6;
    table[5 * 256 + 62] = 6;
    table[5 * 256 + 63] = 6;
    table[5 * 256 + 64] = 6;
    table[5 * 256 + 65] = 6;
    table[5 * 256 + 66] = 6;
    table[5 * 256 + 67] = 6;
    table[5 * 256 + 68] = 6;
    table[5 * 256 + 69] = 6;
    table[5 * 256 + 70] = 6;
    table[5 * 256 + 71] = 6;
    table[5 * 256 + 72] = 6;
    table[5 * 256 + 73] = 6;
    table[5 * 256 + 74] = 6;
    table[5 * 256 + 75] = 6;
    table[5 * 256 + 76] = 6;
    table[5 * 256 + 77] = 6;
    table[5 * 256 + 78] = 6;
    table[5 * 256 + 79] = 6;
    table[5 * 256 + 80] = 6;
    table[5 * 256 + 81] = 6;
    table[5 * 256 + 82] = 6;
    table[5 * 256 + 83] = 6;
    table[5 * 256 + 84] = 6;
    table[5 * 256 + 85] = 6;
    table[5 * 256 + 86] = 6;
    table[5 * 256 + 87] = 6;
    table[5 * 256 + 88] = 6;
    table[5 * 256 + 89] = 6;
    table[5 * 256 + 90] = 6;
    table[5 * 256 + 91] = 6;
    table[5 * 256 + 92] = 6;
    table[5 * 256 + 93] = 6;
    table[5 * 256 + 94] = 6;
    table[5 * 256 + 95] = 6;
    table[5 * 256 + 96] = 6;
    table[5 * 256 + 97] = 6;
    table[5 * 256 + 98] = 6;
    table[5 * 256 + 99] = 6;
    table[5 * 256 + 100] = 6;
    table[5 * 256 + 101] = 6;
    table[5 * 256 + 102] = 6;
    table[5 * 256 + 103] = 6;
    table[5 * 256 + 104] = 6;
    table[5 * 256 + 105] = 6;
    table[5 * 256 + 106] = 6;
    table[5 * 256 + 107] = 6;
    table[5 * 256 + 108] = 6;
    table[5 * 256 + 109] = 6;
    table[5 * 256 + 110] = 6;
    table[5 * 256 + 111] = 6;
    table[5 * 256 + 112] = 6;
    table[5 * 256 + 113] = 6;
    table[5 * 256 + 114] = 6;
    table[5 * 256 + 115] = 6;
    table[5 * 256 + 116] = 6;
    table[5 * 256 + 117] = 6;
    table[5 * 256 + 118] = 6;
    table[5 * 256 + 119] = 6;
    table[5 * 256 + 120] = 6;
    table[5 * 256 + 121] = 6;
    table[5 * 256 + 122] = 6;
    table[5 * 256 + 123] = 6;
    table[5 * 256 + 124] = 6;
    table[5 * 256 + 125] = 6;
    table[5 * 256 + 126] = 6;
    table[5 * 256 + 127] = 6;
    table[5 * 256 + 194] = 7;
    table[5 * 256 + 195] = 7;
    table[5 * 256 + 196] = 7;
    table[5 * 256 + 197] = 7;
    table[5 * 256 + 198] = 7;
    table[5 * 256 + 199] = 7;
    table[5 * 256 + 200] = 7;
    table[5 * 256 + 201] = 7;
    table[5 * 256 + 202] = 7;
    table[5 * 256 + 203] = 7;
    table[5 * 256 + 204] = 7;
    table[5 * 256 + 205] = 7;
    table[5 * 256 + 206] = 7;
    table[5 * 256 + 207] = 7;
    table[5 * 256 + 208] = 7;
    table[5 * 256 + 209] = 7;
    table[5 * 256 + 210] = 7;
    table[5 * 256 + 211] = 7;
    table[5 * 256 + 212] = 7;
    table[5 * 256 + 213] = 7;
    table[5 * 256 + 214] = 7;
    table[5 * 256 + 215] = 7;
    table[5 * 256 + 216] = 7;
    table[5 * 256 + 217] = 7;
    table[5 * 256 + 218] = 7;
    table[5 * 256 + 219] = 7;
    table[5 * 256 + 220] = 7;
    table[5 * 256 + 221] = 7;
    table[5 * 256 + 222] = 7;
    table[5 * 256 + 223] = 7;
    table[5 * 256 + 224] = 8;
    table[5 * 256 + 225] = 9;
    table[5 * 256 + 226] = 9;
    table[5 * 256 + 227] = 9;
    table[5 * 256 + 228] = 9;
    table[5 * 256 + 229] = 9;
    table[5 * 256 + 230] = 9;
    table[5 * 256 + 231] = 9;
    table[5 * 256 + 232] = 9;
    table[5 * 256 + 233] = 9;
    table[5 * 256 + 234] = 9;
    table[5 * 256 + 235] = 9;
    table[5 * 256 + 236] = 9;
    table[5 * 256 + 238] = 9;
    table[5 * 256 + 239] = 9;
    table[5 * 256 + 237] = 10;
    table[5 * 256 + 240] = 11;
    table[5 * 256 + 241] = 12;
    table[5 * 256 + 242] = 12;
    table[5 * 256 + 243] = 12;
    table[5 * 256 + 244] = 13;
    table[6 * 256 + 0] = 6;
    table[6 * 256 + 1] = 6;
    table[6 * 256 + 2] = 6;
    table[6 * 256 + 3] = 6;
    table[6 * 256 + 4] = 6;
    table[6 * 256 + 5] = 6;
    table[6 * 256 + 6] = 6;
    table[6 * 256 + 7] = 6;
    table[6 * 256 + 8] = 6;
    table[6 * 256 + 9] = 6;
    table[6 * 256 + 11] = 6;
    table[6 * 256 + 12] = 6;
    table[6 * 256 + 14] = 6;
    table[6 * 256 + 15] = 6;
    table[6 * 256 + 16] = 6;
    table[6 * 256 + 17] = 6;
    table[6 * 256 + 18] = 6;
    table[6 * 256 + 19] = 6;
    table[6 * 256 + 20] = 6;
    table[6 * 256 + 21] = 6;
    table[6 * 256 + 22] = 6;
    table[6 * 256 + 23] = 6;
    table[6 * 256 + 24] = 6;
    table[6 * 256 + 25] = 6;
    table[6 * 256 + 26] = 6;
    table[6 * 256 + 27] = 6;
    table[6 * 256 + 28] = 6;
    table[6 * 256 + 29] = 6;
    table[6 * 256 + 30] = 6;
    table[6 * 256 + 31] = 6;
    table[6 * 256 + 32] = 6;
    table[6 * 256 + 33] = 6;
    table[6 * 256 + 34] = 6;
    table[6 * 256 + 35] = 6;
    table[6 * 256 + 36] = 6;
    table[6 * 256 + 37] = 6;
    table[6 * 256 + 38] = 6;
    table[6 * 256 + 39] = 6;
    table[6 * 256 + 40] = 6;
    table[6 * 256 + 41] = 6;
    table[6 * 256 + 42] = 6;
    table[6 * 256 + 43] = 6;
    table[6 * 256 + 44] = 6;
    table[6 * 256 + 45] = 6;
    table[6 * 256 + 46] = 6;
    table[6 * 256 + 47] = 6;
    table[6 * 256 + 48] = 6;
    table[6 * 256 + 49] = 6;
    table[6 * 256 + 50] = 6;
    table[6 * 256 + 51] = 6;
    table[6 * 256 + 52] = 6;
    table[6 * 256 + 53] = 6;
    table[6 * 256 + 54] = 6;
    table[6 * 256 + 55] = 6;
    table[6 * 256 + 56] = 6;
    table[6 * 256 + 57] = 6;
    table[6 * 256 + 58] = 6;
    table[6 * 256 + 59] = 6;
    table[6 * 256 + 60] = 6;
    table[6 * 256 + 61] = 6;
    table[6 * 256 + 62] = 6;
    table[6 * 256 + 63] = 6;
    table[6 * 256 + 64] = 6;
    table[6 * 256 + 65] = 6;
    table[6 * 256 + 66] = 6;
    table[6 * 256 + 67] = 6;
    table[6 * 256 + 68] = 6;
    table[6 * 256 + 69] = 6;
    table[6 * 256 + 70] = 6;
    table[6 * 256 + 71] = 6;
    table[6 * 256 + 72] = 6;
    table[6 * 256 + 73] = 6;
    table[6 * 256 + 74] = 6;
    table[6 * 256 + 75] = 6;
    table[6 * 256 + 76] = 6;
    table[6 * 256 + 77] = 6;
    table[6 * 256 + 78] = 6;
    table[6 * 256 + 79] = 6;
    table[6 * 256 + 80] = 6;
    table[6 * 256 + 81] = 6;
    table[6 * 256 + 82] = 6;
    table[6 * 256 + 83] = 6;
    table[6 * 256 + 84] = 6;
    table[6 * 256 + 85] = 6;
    table[6 * 256 + 86] = 6;
    table[6 * 256 + 87] = 6;
    table[6 * 256 + 88] = 6;
    table[6 * 256 + 89] = 6;
    table[6 * 256 + 90] = 6;
    table[6 * 256 + 91] = 6;
    table[6 * 256 + 92] = 6;
    table[6 * 256 + 93] = 6;
    table[6 * 256 + 94] = 6;
    table[6 * 256 + 95] = 6;
    table[6 * 256 + 96] = 6;
    table[6 * 256 + 97] = 6;
    table[6 * 256 + 98] = 6;
    table[6 * 256 + 99] = 6;
    table[6 * 256 + 100] = 6;
    table[6 * 256 + 101] = 6;
    table[6 * 256 + 102] = 6;
    table[6 * 256 + 103] = 6;
    table[6 * 256 + 104] = 6;
    table[6 * 256 + 105] = 6;
    table[6 * 256 + 106] = 6;
    table[6 * 256 + 107] = 6;
    table[6 * 256 + 108] = 6;
    table[6 * 256 + 109] = 6;
    table[6 * 256 + 110] = 6;
    table[6 * 256 + 111] = 6;
    table[6 * 256 + 112] = 6;
    table[6 * 256 + 113] = 6;
    table[6 * 256 + 114] = 6;
    table[6 * 256 + 115] = 6;
    table[6 * 256 + 116] = 6;
    table[6 * 256 + 117] = 6;
    table[6 * 256 + 118] = 6;
    table[6 * 256 + 119] = 6;
    table[6 * 256 + 120] = 6;
    table[6 * 256 + 121] = 6;
    table[6 * 256 + 122] = 6;
    table[6 * 256 + 123] = 6;
    table[6 * 256 + 124] = 6;
    table[6 * 256 + 125] = 6;
    table[6 * 256 + 126] = 6;
    table[6 * 256 + 127] = 6;
    table[6 * 256 + 194] = 7;
    table[6 * 256 + 195] = 7;
    table[6 * 256 + 196] = 7;
    table[6 * 256 + 197] = 7;
    table[6 * 256 + 198] = 7;
    table[6 * 256 + 199] = 7;
    table[6 * 256 + 200] = 7;
    table[6 * 256 + 201] = 7;
    table[6 * 256 + 202] = 7;
    table[6 * 256 + 203] = 7;
    table[6 * 256 + 204] = 7;
    table[6 * 256 + 205] = 7;
    table[6 * 256 + 206] = 7;
    table[6 * 256 + 207] = 7;
    table[6 * 256 + 208] = 7;
    table[6 * 256 + 209] = 7;
    table[6 * 256 + 210] = 7;
    table[6 * 256 + 211] = 7;
    table[6 * 256 + 212] = 7;
    table[6 * 256 + 213] = 7;
    table[6 * 256 + 214] = 7;
    table[6 * 256 + 215] = 7;
    table[6 * 256 + 216] = 7;
    table[6 * 256 + 217] = 7;
    table[6 * 256 + 218] = 7;
    table[6 * 256 + 219] = 7;
    table[6 * 256 + 220] = 7;
    table[6 * 256 + 221] = 7;
    table[6 * 256 + 222] = 7;
    table[6 * 256 + 223] = 7;
    table[6 * 256 + 224] = 8;
    table[6 * 256 + 225] = 9;
    table[6 * 256 + 226] = 9;
    table[6 * 256 + 227] = 9;
    table[6 * 256 + 228] = 9;
    table[6 * 256 + 229] = 9;
    table[6 * 256 + 230] = 9;
    table[6 * 256 + 231] = 9;
    table[6 * 256 + 232] = 9;
    table[6 * 256 + 233] = 9;
    table[6 * 256 + 234] = 9;
    table[6 * 256 + 235] = 9;
    table[6 * 256 + 236] = 9;
    table[6 * 256 + 238] = 9;
    table[6 * 256 + 239] = 9;
    table[6 * 256 + 237] = 10;
    table[6 * 256 + 240] = 11;
    table[6 * 256 + 241] = 12;
    table[6 * 256 + 242] = 12;
    table[6 * 256 + 243] = 12;
    table[6 * 256 + 244] = 13;
    table[6 * 256 + 13] = 14;
    table[7 * 256 + 128] = 6;
    table[7 * 256 + 129] = 6;
    table[7 * 256 + 130] = 6;
    table[7 * 256 + 131] = 6;
    table[7 * 256 + 132] = 6;
    table[7 * 256 + 133] = 6;
    table[7 * 256 + 134] = 6;
    table[7 * 256 + 135] = 6;
    table[7 * 256 + 136] = 6;
    table[7 * 256 + 137] = 6;
    table[7 * 256 + 138] = 6;
    table[7 * 256 + 139] = 6;
    table[7 * 256 + 140] = 6;
    table[7 * 256 + 141] = 6;
    table[7 * 256 + 142] = 6;
    table[7 * 256 + 143] = 6;
    table[7 * 256 + 144] = 6;
    table[7 * 256 + 145] = 6;
    table[7 * 256 + 146] = 6;
    table[7 * 256 + 147] = 6;
    table[7 * 256 + 148] = 6;
    table[7 * 256 + 149] = 6;
    table[7 * 256 + 150] = 6;
    table[7 * 256 + 151] = 6;
    table[7 * 256 + 152] = 6;
    table[7 * 256 + 153] = 6;
    table[7 * 256 + 154] = 6;
    table[7 * 256 + 155] = 6;
    table[7 * 256 + 156] = 6;
    table[7 * 256 + 157] = 6;
    table[7 * 256 + 158] = 6;
    table[7 * 256 + 159] = 6;
    table[7 * 256 + 160] = 6;
    table[7 * 256 + 161] = 6;
    table[7 * 256 + 162] = 6;
    table[7 * 256 + 163] = 6;
    table[7 * 256 + 164] = 6;
    table[7 * 256 + 165] = 6;
    table[7 * 256 + 166] = 6;
    table[7 * 256 + 167] = 6;
    table[7 * 256 + 168] = 6;
    table[7 * 256 + 169] = 6;
    table[7 * 256 + 170] = 6;
    table[7 * 256 + 171] = 6;
    table[7 * 256 + 172] = 6;
    table[7 * 256 + 173] = 6;
    table[7 * 256 + 174] = 6;
    table[7 * 256 + 175] = 6;
    table[7 * 256 + 176] = 6;
    table[7 * 256 + 177] = 6;
    table[7 * 256 + 178] = 6;
    table[7 * 256 + 179] = 6;
    table[7 * 256 + 180] = 6;
    table[7 * 256 + 181] = 6;
    table[7 * 256 + 182] = 6;
    table[7 * 256 + 183] = 6;
    table[7 * 256 + 184] = 6;
    table[7 * 256 + 185] = 6;
    table[7 * 256 + 186] = 6;
    table[7 * 256 + 187] = 6;
    table[7 * 256 + 188] = 6;
    table[7 * 256 + 189] = 6;
    table[7 * 256 + 190] = 6;
    table[7 * 256 + 191] = 6;
    table[8 * 256 + 160] = 7;
    table[8 * 256 + 161] = 7;
    table[8 * 256 + 162] = 7;
    table[8 * 256 + 163] = 7;
    table[8 * 256 + 164] = 7;
    table[8 * 256 + 165] = 7;
    table[8 * 256 + 166] = 7;
    table[8 * 256 + 167] = 7;
    table[8 * 256 + 168] = 7;
    table[8 * 256 + 169] = 7;
    table[8 * 256 + 170] = 7;
    table[8 * 256 + 171] = 7;
    table[8 * 256 + 172] = 7;
    table[8 * 256 + 173] = 7;
    table[8 * 256 + 174] = 7;
    table[8 * 256 + 175] = 7;
    table[8 * 256 + 176] = 7;
    table[8 * 256 + 177] = 7;
    table[8 * 256 + 178] = 7;
    table[8 * 256 + 179] = 7;
    table[8 * 256 + 180] = 7;
    table[8 * 256 + 181] = 7;
    table[8 * 256 + 182] = 7;
    table[8 * 256 + 183] = 7;
    table[8 * 256 + 184] = 7;
    table[8 * 256 + 185] = 7;
    table[8 * 256 + 186] = 7;
    table[8 * 256 + 187] = 7;
    table[8 * 256 + 188] = 7;
    table[8 * 256 + 189] = 7;
    table[8 * 256 + 190] = 7;
    table[8 * 256 + 191] = 7;
    table[9 * 256 + 128] = 7;
    table[9 * 256 + 129] = 7;
    table[9 * 256 + 130] = 7;
    table[9 * 256 + 131] = 7;
    table[9 * 256 + 132] = 7;
    table[9 * 256 + 133] = 7;
    table[9 * 256 + 134] = 7;
    table[9 * 256 + 135] = 7;
    table[9 * 256 + 136] = 7;
    table[9 * 256 + 137] = 7;
    table[9 * 256 + 138] = 7;
    table[9 * 256 + 139] = 7;
    table[9 * 256 + 140] = 7;
    table[9 * 256 + 141] = 7;
    table[9 * 256 + 142] = 7;
    table[9 * 256 + 143] = 7;
    table[9 * 256 + 144] = 7;
    table[9 * 256 + 145] = 7;
    table[9 * 256 + 146] = 7;
    table[9 * 256 + 147] = 7;
    table[9 * 256 + 148] = 7;
    table[9 * 256 + 149] = 7;
    table[9 * 256 + 150] = 7;
    table[9 * 256 + 151] = 7;
    table[9 * 256 + 152] = 7;
    table[9 * 256 + 153] = 7;
    table[9 * 256 + 154] = 7;
    table[9 * 256 + 155] = 7;
    table[9 * 256 + 156] = 7;
    table[9 * 256 + 157] = 7;
    table[9 * 256 + 158] = 7;
    table[9 * 256 + 159] = 7;
    table[9 * 256 + 160] = 7;
    table[9 * 256 + 161] = 7;
    table[9 * 256 + 162] = 7;
    table[9 * 256 + 163] = 7;
    table[9 * 256 + 164] = 7;
    table[9 * 256 + 165] = 7;
    table[9 * 256 + 166] = 7;
    table[9 * 256 + 167] = 7;
    table[9 * 256 + 168] = 7;
    table[9 * 256 + 169] = 7;
    table[9 * 256 + 170] = 7;
    table[9 * 256 + 171] = 7;
    table[9 * 256 + 172] = 7;
    table[9 * 256 + 173] = 7;
    table[9 * 256 + 174] = 7;
    table[9 * 256 + 175] = 7;
    table[9 * 256 + 176] = 7;
    table[9 * 256 + 177] = 7;
    table[9 * 256 + 178] = 7;
    table[9 * 256 + 179] = 7;
    table[9 * 256 + 180] = 7;
    table[9 * 256 + 181] = 7;
    table[9 * 256 + 182] = 7;
    table[9 * 256 + 183] = 7;
    table[9 * 256 + 184] = 7;
    table[9 * 256 + 185] = 7;
    table[9 * 256 + 186] = 7;
    table[9 * 256 + 187] = 7;
    table[9 * 256 + 188] = 7;
    table[9 * 256 + 189] = 7;
    table[9 * 256 + 190] = 7;
    table[9 * 256 + 191] = 7;
    table[10 * 256 + 128] = 7;
    table[10 * 256 + 129] = 7;
    table[10 * 256 + 130] = 7;
    table[10 * 256 + 131] = 7;
    table[10 * 256 + 132] = 7;
    table[10 * 256 + 133] = 7;
    table[10 * 256 + 134] = 7;
    table[10 * 256 + 135] = 7;
    table[10 * 256 + 136] = 7;
    table[10 * 256 + 137] = 7;
    table[10 * 256 + 138] = 7;
    table[10 * 256 + 139] = 7;
    table[10 * 256 + 140] = 7;
    table[10 * 256 + 141] = 7;
    table[10 * 256 + 142] = 7;
    table[10 * 256 + 143] = 7;
    table[10 * 256 + 144] = 7;
    table[10 * 256 + 145] = 7;
    table[10 * 256 + 146] = 7;
    table[10 * 256 + 147] = 7;
    table[10 * 256 + 148] = 7;
    table[10 * 256 + 149] = 7;
    table[10 * 256 + 150] = 7;
    table[10 * 256 + 151] = 7;
    table[10 * 256 + 152] = 7;
    table[10 * 256 + 153] = 7;
    table[10 * 256 + 154] = 7;
    table[10 * 256 + 155] = 7;
    table[10 * 256 + 156] = 7;
    table[10 * 256 + 157] = 7;
    table[10 * 256 + 158] = 7;
    table[10 * 256 + 159] = 7;
    table[11 * 256 + 144] = 9;
    table[11 * 256 + 145] = 9;
    table[11 * 256 + 146] = 9;
    table[11 * 256 + 147] = 9;
    table[11 * 256 + 148] = 9;
    table[11 * 256 + 149] = 9;
    table[11 * 256 + 150] = 9;
    table[11 * 256 + 151] = 9;
    table[11 * 256 + 152] = 9;
    table[11 * 256 + 153] = 9;
    table[11 * 256 + 154] = 9;
    table[11 * 256 + 155] = 9;
    table[11 * 256 + 156] = 9;
    table[11 * 256 + 157] = 9;
    table[11 * 256 + 158] = 9;
    table[11 * 256 + 159] = 9;
    table[11 * 256 + 160] = 9;
    table[11 * 256 + 161] = 9;
    table[11 * 256 + 162] = 9;
    table[11 * 256 + 163] = 9;
    table[11 * 256 + 164] = 9;
    table[11 * 256 + 165] = 9;
    table[11 * 256 + 166] = 9;
    table[11 * 256 + 167] = 9;
    table[11 * 256 + 168] = 9;
    table[11 * 256 + 169] = 9;
    table[11 * 256 + 170] = 9;
    table[11 * 256 + 171] = 9;
    table[11 * 256 + 172] = 9;
    table[11 * 256 + 173] = 9;
    table[11 * 256 + 174] = 9;
    table[11 * 256 + 175] = 9;
    table[11 * 256 + 176] = 9;
    table[11 * 256 + 177] = 9;
    table[11 * 256 + 178] = 9;
    table[11 * 256 + 179] = 9;
    table[11 * 256 + 180] = 9;
    table[11 * 256 + 181] = 9;
    table[11 * 256 + 182] = 9;
    table[11 * 256 + 183] = 9;
    table[11 * 256 + 184] = 9;
    table[11 * 256 + 185] = 9;
    table[11 * 256 + 186] = 9;
    table[11 * 256 + 187] = 9;
    table[11 * 256 + 188] = 9;
    table[11 * 256 + 189] = 9;
    table[11 * 256 + 190] = 9;
    table[11 * 256 + 191] = 9;
    table[12 * 256 + 128] = 9;
    table[12 * 256 + 129] = 9;
    table[12 * 256 + 130] = 9;
    table[12 * 256 + 131] = 9;
    table[12 * 256 + 132] = 9;
    table[12 * 256 + 133] = 9;
    table[12 * 256 + 134] = 9;
    table[12 * 256 + 135] = 9;
    table[12 * 256 + 136] = 9;
    table[12 * 256 + 137] = 9;
    table[12 * 256 + 138] = 9;
    table[12 * 256 + 139] = 9;
    table[12 * 256 + 140] = 9;
    table[12 * 256 + 141] = 9;
    table[12 * 256 + 142] = 9;
    table[12 * 256 + 143] = 9;
    table[12 * 256 + 144] = 9;
    table[12 * 256 + 145] = 9;
    table[12 * 256 + 146] = 9;
    table[12 * 256 + 147] = 9;
    table[12 * 256 + 148] = 9;
    table[12 * 256 + 149] = 9;
    table[12 * 256 + 150] = 9;
    table[12 * 256 + 151] = 9;
    table[12 * 256 + 152] = 9;
    table[12 * 256 + 153] = 9;
    table[12 * 256 + 154] = 9;
    table[12 * 256 + 155] = 9;
    table[12 * 256 + 156] = 9;
    table[12 * 256 + 157] = 9;
    table[12 * 256 + 158] = 9;
    table[12 * 256 + 159] = 9;
    table[12 * 256 + 160] = 9;
    table[12 * 256 + 161] = 9;
    table[12 * 256 + 162] = 9;
    table[12 * 256 + 163] = 9;
    table[12 * 256 + 164] = 9;
    table[12 * 256 + 165] = 9;
    table[12 * 256 + 166] = 9;
    table[12 * 256 + 167] = 9;
    table[12 * 256 + 168] = 9;
    table[12 * 256 + 169] = 9;
    table[12 * 256 + 170] = 9;
    table[12 * 256 + 171] = 9;
    table[12 * 256 + 172] = 9;
    table[12 * 256 + 173] = 9;
    table[12 * 256 + 174] = 9;
    table[12 * 256 + 175] = 9;
    table[12 * 256 + 176] = 9;
    table[12 * 256 + 177] = 9;
    table[12 * 256 + 178] = 9;
    table[12 * 256 + 179] = 9;
    table[12 * 256 + 180] = 9;
    table[12 * 256 + 181] = 9;
    table[12 * 256 + 182] = 9;
    table[12 * 256 + 183] = 9;
    table[12 * 256 + 184] = 9;
    table[12 * 256 + 185] = 9;
    table[12 * 256 + 186] = 9;
    table[12 * 256 + 187] = 9;
    table[12 * 256 + 188] = 9;
    table[12 * 256 + 189] = 9;
    table[12 * 256 + 190] = 9;
    table[12 * 256 + 191] = 9;
    table[13 * 256 + 128] = 9;
    table[13 * 256 + 129] = 9;
    table[13 * 256 + 130] = 9;
    table[13 * 256 + 131] = 9;
    table[13 * 256 + 132] = 9;
    table[13 * 256 + 133] = 9;
    table[13 * 256 + 134] = 9;
    table[13 * 256 + 135] = 9;
    table[13 * 256 + 136] = 9;
    table[13 * 256 + 137] = 9;
    table[13 * 256 + 138] = 9;
    table[13 * 256 + 139] = 9;
    table[13 * 256 + 140] = 9;
    table[13 * 256 + 141] = 9;
    table[13 * 256 + 142] = 9;
    table[13 * 256 + 143] = 9;
    table[14 * 256 + 10] = 15;


    table
}