return {
    {
        Job = {
            name = 'burgershot',
            label = 'Burgershot',
            grades = {
                { label = 'Employee' },
                { label = 'Manager', accountRole = 'manager' },
                { label = 'CEO', accountRole = 'owner' }
            },
            type = 'restaurant',
            hasAccount = true,
        },
        Stashes = {
            Fridge = {
                slots = 25,
                maxWeight = 125000,
                coords = vec3(-55.47, -1097.09, 26.0),
                size = vec3(1.05, 1.35, 1.3),
                rotation = 88.75,
            },
            Storage = nil,
            Freezer = nil,
        },
        Clockin = {
            coords = vec3(-58.0, -1098.0, 21.0),
            size = vec3(1.05, 1.35, 1.3),
            rotation = 88.75,
        },
        Crafting = {
            {
                coords = vec3(-58.0, -1098.0, 26.0),
                size = vec3(1.05, 1.35, 1.3),
                rotation = 88.75,
                label = 'Grill',
                icon = 'fas fa-burger',
                recipes = { 'test_craft' },
            }
        },
    }
}