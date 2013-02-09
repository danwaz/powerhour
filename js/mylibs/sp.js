var models, powerhour, sp;

powerhour = this;

sp = getSpotifyApi(1);

models = sp.require("sp://import/scripts/api/models");

powerhour.sp = sp;

powerhour.models = models;