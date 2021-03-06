package de.timmi6790.statsbotdiscord.modules.core;

import de.timmi6790.statsbotdiscord.AbstractModule;
import de.timmi6790.statsbotdiscord.StatsBot;
import de.timmi6790.statsbotdiscord.modules.core.commands.info.AboutCommand;
import de.timmi6790.statsbotdiscord.modules.core.commands.info.AccountDeletionCommand;
import de.timmi6790.statsbotdiscord.modules.core.commands.info.HelpCommand;
import de.timmi6790.statsbotdiscord.modules.core.commands.info.InviteCommand;
import de.timmi6790.statsbotdiscord.modules.core.commands.management.BotInfoCommand;
import de.timmi6790.statsbotdiscord.modules.core.commands.management.UserInfoCommand;
import de.timmi6790.statsbotdiscord.modules.core.settings.CommandAutoCorrectSetting;

import java.util.*;

public class CoreModule extends AbstractModule {
    public CoreModule() {
        super("Core");
    }

    @Override
    public void onEnable() {
        this.registerDatabaseMappings();
        StatsBot.getCommandManager().registerCommands(
                new HelpCommand(),
                new AboutCommand(),
                new BotInfoCommand(),
                new UserInfoCommand(),
                new InviteCommand(),
                new AccountDeletionCommand()
        );

        StatsBot.getSettingManager().registerSettings(
                new CommandAutoCorrectSetting()
        );
    }

    @Override
    public void onDisable() {

    }

    private void registerDatabaseMappings() {
        StatsBot.getDatabase().registerRowMapper(ChannelDb.class, (rs, ctx) -> {
            if (rs.getInt("id") == 0) {
                return null;
            }

            return new ChannelDb(rs.getInt("id"), rs.getLong("discordId"),
                    GuildDb.getOrCreate(rs.getLong("serverDiscordId")), rs.getBoolean("disabled"));

        }).registerRowMapper(GuildDb.class, (rs, ctx) -> {
            if (rs.getInt("id") == 0) {
                return null;
            }

            final String aliases = rs.getString("aliases");
            String[] aliasList = aliases == null ? new String[]{} : aliases.split(",");

            return new GuildDb(rs.getInt("id"), rs.getLong("discordId"), rs.getBoolean("banned"),
                    new HashSet<>(Arrays.asList(aliasList)), null);

        }).registerRowMapper(UserDb.class, (rs, ctx) -> {
            if (rs.getInt("id") == 0) {
                return null;
            }

            final String perms = rs.getString("perms");
            final String[] permList = perms == null ? new String[]{} : perms.split(",");

            final Map<Integer, String> settings = new HashMap<>();
            if (rs.getString("settings") != null) {
                for (final String setting : rs.getString("settings").split(";")) {
                    final String[] values = setting.split(",");
                    if (values.length != 2) {
                        continue;
                    }

                    settings.put(Integer.parseInt(values[0]), values[1]);
                }
            }
            return new UserDb(rs.getInt("id"), rs.getLong("discordId"), null, new ArrayList<>(),
                    rs.getBoolean("banned"), rs.getLong("shopPoints"),
                    new ArrayList<>(Arrays.asList(permList)), settings);
        });
    }
}

