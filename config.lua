Config = {}

Config.RestrictedChannels = {
    [1] = {
        police = true,
		bcso = true,
        ambulance = true
    },
    [2] = {
        police = true,
		bcso = true,
        ambulance = true
    },
    [3] = {
        police = true,
		bcso = true,
        ambulance = true
    },
    [4] = {
        police = true,
		bcso = true,
        ambulance = true
    },
    [5] = {
        police = true,
		bcso = true,
        ambulance = true
    },
    [6] = {
        police = true,
		bcso = true,
        ambulance = true
    },
    [7] = {
        police = true,
		bcso = true,
        ambulance = true
    },
    [8] = {
        police = true,
		bcso = true,
        ambulance = true
    },
    [9] = {
        police = true,
		bcso = true,
        ambulance = true
    },
    [10] = {
        police = true,
		bcso = true,
        ambulance = true
    }
}

Config.MaxFrequency = 500

Config.messages = {
    ["not_on_radio"] = "You're not connected to a signal",
    ["on_radio"] = "You're already connected to this signal",
    ["joined_to_radio"] = "You're connected to: ",
    ["restricted_channel_error"] = "You can not connect to this signal!",
    ["invalid_radio"] = "This frequency is not available.",
    ["you_on_radio"] = "You're already connected to this channel",
    ["you_leave"] = "You left the channel.",
    ['volume_radio'] = 'New volume ',
    ['decrease_radio_volume'] = 'The radio is already set to maximum volume',
    ['increase_radio_volume'] = 'The radio is already set to the lowest volume',
    ['increase_decrease_radio_channel'] = 'New channel ',
}




Config.UsableProps = {
    ["megaphone"] = {
        ["type"] = "others" ,
        ["animDict"] = "amb@world_human_mobile_film_shocking@female@base",
        ["flags"] = 49,
        ["anim"] = "base",
        ["prop"] = `prop_megaphone_01`,
        ["attach"] = {
            ["bone"] = 28422,
            ["x"] = 0.04,
            ["y"] = -0.01,
            ["z"] = 0.0,
            ["xR"] = 22.0,
            ["yR"] = -4.0,
            ["zR"] = 87.0,
            ["vertexIndex"] = 0
        },
    },
}