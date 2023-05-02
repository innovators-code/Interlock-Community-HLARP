local PLUGIN = PLUGIN

PLUGIN.name = "Quiz System"
PLUGIN.author = "Riggs.mackay"
PLUGIN.description = "A quiz system for the server."

ix.quiz = ix.quiz or {}
ix.quiz.questions = ix.quiz.questions or {}

-- Set to false to disable the quiz system.
ix.quiz.enabled = true

-- should they be kicked after they fail?
ix.quiz.kick = true

-- should they be banned after they fail?
ix.quiz.ban = false

-- how long should they be banned for?
ix.quiz.banlength = 3600 -- 24 hours

-- quiz questions, literally..
ix.quiz.questions = {
    [1] = {
        message = "What is the name of the server?",
        options = {
            [1] = "Conflict Studios",
            [2] = "Affiliation Networks",
            [3] = "Overlord Community",
            [4] = "Lite Network",
        },
        correct = 1,
    },
    [2] = {
        message = "are u gay",
        options = {
            [1] = "Yes, I am vin.",
            [2] = "No.",
        },
        correct = 2,
    },
}

function ix.quiz.GetQuestions()
   return ix.quiz.questions 
end

function ix.quiz.GetQuestion(id)
    return ix.quiz.questions[id]
end

function ix.quiz.GetMessage(id)
    return ix.quiz.questions[id].message
end

function ix.quiz.GetOptions(id)
    return ix.quiz.questions[id].options
end

function ix.quiz.GetCorrectAnswer(id)
    return ix.quiz.questions[id].correct
end