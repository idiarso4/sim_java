package com.simjava.domain.security;

import com.simjava.domain.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
@Entity
@Table(name = "users")
public class User extends BaseEntity implements UserDetails {
    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(name = "email_verified_at")
    private Date emailVerifiedAt;

    @Column(nullable = false)
    private String password;

    @Column(name = "remember_token")
    private String rememberToken;

    private String image;

    @Column(name = "user_type", nullable = false)
    @Builder.Default
    private String userType = "siswa";

    @Column(nullable = false)
    @Builder.Default
    private String role = "siswa";

    @Column(nullable = false)
    @Builder.Default
    private String status = "aktif";

    @Column(name = "class_room_id")
    private Long classRoomId;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singleton((GrantedAuthority) () -> role);
    }

    @Override
    public String getUsername() {
        return email; // Using email as username
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return "aktif".equals(status);
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return "aktif".equals(status);
    }
}
